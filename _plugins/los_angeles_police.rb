# frozen_string_literal: true

module LosAngelesPolice
  OPEN_OVERSIGHT_DEPARTMENT_ID = '3'
  OPEN_OVERSIGHT_GENDER_MAP = {
    'MALE' => 'M',
    'FEMALE' => 'F',
    'NONBINNARY' => 'Other' # [sic] misspelled in roster
  }.freeze
  OPEN_OVERSIGHT_RACE_MAP = {
    'ASIAN/PAC' => 'Not Sure', # could be Asian, could be Pacific Islander
    'AMERIIND' => 'NATIVE AMERICAN',
    'BLACK' => 'BLACK',
    'CAUCASIAN' => 'WHITE',
    'FILIPINO' => 'Other',
    'HISPANIC' => 'HISPANIC',
    'OTHER' => 'Other'
  }.freeze

  class Generator < Jekyll::Generator
    attr_accessor :site

    def generate(site)
      @site = site

      deriveData

      cops.each do |cop|
        site.pages << CopPage.new(site, cop)
      end

      site.pages << OpenInsightCsv.new(site)
    end

    def cops
      site.data['us']['ca']['police']['los_angeles']['roster-2022-08-20']
    end

    def deriveData
      cops.each do |cop|
        cop['open_oversight_department_id'] = OPEN_OVERSIGHT_DEPARTMENT_ID

        names = splitNames(cop['EmployeeName'])
        cop['last_name'] = names[:last_name]
        cop['first_name'] = names[:first_name]
        cop['middle_initial'] = names[:middle_initial]

        cop['open_oversight_gender'] = OPEN_OVERSIGHT_GENDER_MAP[cop['Sex']]
        raise "Unknown gender #{cop['Sex']}" if cop['open_oversight_gender'].nil?

        cop['open_oversight_race'] = OPEN_OVERSIGHT_RACE_MAP[cop['Ethnicity']]
        raise "Unknown race #{cop['Ethnicity']}" if cop['open_oversight_race'].nil?
      end
    end

    def splitNames(name)
      middle_initial = ''
      last_name, first_name = name.split(', ')

      if first_name.match(/^(.*)\s(\w)$/)
        first_name = Regexp.last_match[1]
        middle_initial = Regexp.last_match[2]
      end

      {
        last_name: last_name,
        first_name: first_name,
        middle_initial: middle_initial,
      }
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
    def initialize(site)
      @content = page_template

      super(site, __dir__, '', filename)
    end

    def filename
      "us/ca/police/los_angeles/open_oversight.csv"
    end

    def page_template
      @page_template ||= File.read(page_template_path)
    end

    def page_template_path
      File.expand_path('./los_angeles_police/open_oversight.csv', __dir__)
    end
  end
end
