# frozen_string_literal: true

module LosAngelesPolice
  class Generator < Jekyll::Generator
    attr_accessor :site

    class Rank
      @@MAP = {}

      attr_reader :name, :open_oversight_id

      def initialize(name:, open_oversight_id: nil)
        @name = name
        @open_oversight_id = open_oversight_id
      end

      def self.get(code)
        raise "Unknown rank #{code}" if @@MAP[code].nil?

        @@MAP[code]
      end

      def self.register(code:, name:, open_oversight_id:)
        @@MAP[code] = Rank.new(name: name, open_oversight_id: open_oversight_id)
      end

      def self.load_file
        YAML.load_file(File.join(__dir__, 'rank.yml')).each do |rank|
          Rank.register(
            code: rank['code'],
            name: rank['name'],
            open_oversight_id: rank['open_oversight_id'],
          )
        end
      end
    end

    class Area
      @@MAP = {}

      attr_reader :name, :open_oversight_id

      def initialize(name:, open_oversight_id: nil)
        @name = name
        @open_oversight_id = open_oversight_id
      end

      def self.get(code)
        raise "Unknown area #{code}" if @@MAP[code].nil?

        @@MAP[code]
      end

      def self.register(code:, name:, open_oversight_id:)
        @@MAP[code] = Area.new(name: name, open_oversight_id: open_oversight_id)
      end

      def self.load_file
        YAML.load_file(File.join(__dir__, 'area.yml')).each do |area|
          Area.register(
            code: area['code'],
            name: area['name'],
            open_oversight_id: area['open_oversight_id'],
          )
        end
      end
    end

    def generate(site)
      @site = site

      Rank.load_file
      Area.load_file

      derive_names
      derive_rank
      derive_area

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

    def derive_area
      cops.each do |cop|
        cop['area'] = Area.get(cop['Area']).name
      end
    end

    def derive_rank
      cops.each do |cop|
        cop['rank'] = Rank.get(cop['RankTile']).name
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
    DEPARTMENT_ID = '24'
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
