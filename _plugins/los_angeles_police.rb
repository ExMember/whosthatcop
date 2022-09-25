# frozen_string_literal: true

module LosAngelesPolice
  class Generator < Jekyll::Generator
    attr_accessor :site

    RANK_MAP = {
      'COP' => 'CHIEF OF POLICE',
      'AC' => 'ASSITANT CHIEF',
      # 'DEP CHF' => 'POLICE DEPUTY CHIEF II',
      # 'DEP CHF' => 'POLICE DEPUTY CHIEF I',
      'DEP CHF' => 'POLICE DEPUTY CHIEF', # Roster doesn't distinguish between I and II
      'MSGT' => 'MUNICIPAL POLICE SERGEANT',
      'CMDR' => 'POLICE COMMANDER',
      # 'MCAPT 2' => 'MUNICIPAL POLICE CAPTAIN II',
      'MCAPT 1' => 'MUNICIPAL POLICE CAPTAIN I',
      'CAPT 3' => 'POLICE CAPTAIN III',
      'CAPT 2' => 'POLICE CAPTAIN II',
      'CAPT 1' => 'POLICE CAPTAIN I',
      'LT 2' => 'POLICE LIEUTENANT II',
      'LT 1' => 'POLICE LIEUTENANT I',
      'DET 3' => 'POLICE DETECTIVE III',
      'DET 2' => 'POLICE DETECTIVE II',
      'DET 1' => 'POLICE DETECTIVE I',
      'SGT 2' => 'POLICE SERGEANT II',
      'SGT 1' => 'POLICE SERGEANT I',
      # 'MPO' => 'MUNICIPAL POLICE OFFICER III',
      'PO 3' => 'POLICE OFFICER III',
      'PO 2' => 'POLICE OFFICER II',
      'PO 1' => 'POLICE OFFICER I',
      'PO SPEC' => 'POLICE SPECIALIST',
      'MPO' => 'MPO', # Unknown
    }.freeze

    def generate(site)
      @site = site
      derive_names
      derive_rank

      cops.each do |cop|
        site.pages << CopPage.new(site, cop)
      end

      site.pages << OpenInsightCsv.new(site, cops)
    end

    def cops
      site.data['us']['ca']['police']['los_angeles']['roster-2022-08-20']
    end

    def derive_names
      cops.each do |cop|
        names = split_names(cop['EmployeeName'])

        cop['last_name'] = names[:last_name]
        cop['first_name'] = names[:first_name]
        cop['middle_initial'] = names[:middle_initial]
      end
    end

    def derive_rank
      cops.each do |cop|
        raise "Unknown rank #{cop['RankTile']}" if RANK_MAP[cop['RankTile']].nil?

        cop['rank'] = RANK_MAP[cop['RankTile']]
      end
    end

    def split_names(name)
      middle_initial = ''
      last_name, first_name = name.split(', ')

      if first_name.match(/^(.*)\s(\w)$/)
        first_name = Regexp.last_match[1]
        middle_initial = Regexp.last_match[2]
      end

      { last_name:, first_name:, middle_initial: }
    end
  end

  class CopPage < Jekyll::PageWithoutAFile
    def initialize(site, cop)
      @data = cop.merge(
        'layout' => 'page',
        'title' => cop['EmployeeName'],
      )
      @content = page_template

      super(site, __dir__, '', filename)
    end

    def filename
      "us/ca/police/los_angeles/#{data['SerialNo']}.html"
    end

    def page_template
      @page_template ||= File.read(page_template_path)
    end

    def page_template_path
      File.expand_path('./los_angeles_police/cop.html', __dir__)
    end
  end

  class OpenInsightCsv < Jekyll::PageWithoutAFile
    DEPARTMENT_ID = '19'
    GENDER_MAP = {
      'MALE' => 'M',
      'FEMALE' => 'F',
      'NONBINNARY' => 'Other' # [sic] misspelled in roster
    }.freeze
    RACE_MAP = {
      'ASIAN/PAC' => 'Not Sure', # could be Asian, could be Pacific Islander
      'AMERIIND' => 'NATIVE AMERICAN',
      'BLACK' => 'BLACK',
      'CAUCASIAN' => 'WHITE',
      'FILIPINO' => 'Other',
      'HISPANIC' => 'HISPANIC',
      'OTHER' => 'Other'
    }.freeze

    attr_accessor :cops

    def initialize(site, cops)
      @cops = cops
      site.data['us']['ca']['police']['los_angeles']['open_oversight_data'] =
        cops.map do |cop|
          cop_data(cop)
        end

      @content = page_template
      super(site, __dir__, '', filename)
    end

    def cop_data(cop)
      raise "Unknown gender #{cop['Sex']}" if GENDER_MAP[cop['Sex']].nil?
      raise "Unknown race #{cop['Ethnicity']}" if RACE_MAP[cop['Ethnicity']].nil?

      {
        'department_id' => DEPARTMENT_ID,
        'unique_internal_identifier' => cop['SerialNo'],
        'last_name' => cop['last_name'],
        'first_name' => cop['first_name'],
        'middle_initial' => cop['middle_initial'],
        'gender' => GENDER_MAP[cop['Sex']],
        'race' => RACE_MAP[cop['Ethnicity']],
      }
    end

    def filename
      'us/ca/police/los_angeles/open_oversight.csv'
    end

    def page_template
      @page_template ||= File.read(page_template_path)
    end

    def page_template_path
      File.expand_path('./los_angeles_police/open_oversight.csv', __dir__)
    end
  end
end
