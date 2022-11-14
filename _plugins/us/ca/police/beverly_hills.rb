# frozen_string_literal: true

module BeverlyHills
  class Generator < Jekyll::Generator
    attr_accessor :site

    # class Rank
    #   @@MAP = {}
    #
    #   attr_reader :name, :open_oversight_id
    #
    #   def initialize(name:, open_oversight_id: nil)
    #     @name = name
    #     @open_oversight_id = open_oversight_id
    #   end
    #
    #   def self.get(code)
    #     raise "Unknown rank #{code}" if @@MAP[code].nil?
    #
    #     @@MAP[code]
    #   end
    #
    #   def self.register(code:, name:, open_oversight_id:)
    #     @@MAP[code] = Rank.new(name: name, open_oversight_id: open_oversight_id)
    #   end
    #
    #   def self.load_file
    #     YAML.load_file(File.join(__dir__, 'beverly_hills/rank.yml')).each do |rank|
    #       Rank.register(
    #         code: rank['code'],
    #         name: rank['name'],
    #         open_oversight_id: rank['open_oversight_id'],
    #       )
    #     end
    #   end
    # end

    def generate(site)
      @site = site

      # Rank.load_file

      cops.each do |cop|
        site.pages << CopPage.new(site, cop)
      end

      site.pages << OpenInsightCsv.new(site, cops)
    end

    def cops
      site.data['us']['ca']['police']['beverly_hills']['roster-2022']
    end
  end

  class CopPage < Jekyll::PageWithoutAFile
    def initialize(site, cop)
      @data = cop.merge(
        'layout' => 'page',
        'title' => "#{cop['LastName']}, #{cop['GivenName1']} #{cop['GivenName2']}",
      )
      @content = page_template

      super(site, __dir__, '', filename)
    end

    def filename
      serial = data['SerialNumber'] || 'unknown'
      first = data['GivenName1'].to_s.downcase || 'unknown'
      last = data['LastName'].to_s.downcase || 'unknown'

      "us/ca/police/beverly_hills/#{serial}-#{last}-#{first}.html"
    end

    def page_template
      @page_template ||= File.read(page_template_path)
    end

    def page_template_path
      File.expand_path('./beverly_hills/cop.html', __dir__)
    end
  end

  class OpenInsightCsv < Jekyll::PageWithoutAFile
    DEPARTMENT_ID = '25'

    attr_accessor :cops

    def initialize(site, cops)
      @cops = cops
      site.data['us']['ca']['police']['beverly_hills']['open_oversight_data'] =
        cops.map do |cop|
          cop_data(cop)
        end

      @content = page_template
      super(site, __dir__, '', filename)
    end

    def cop_data(cop)
      {
        'department_id' => DEPARTMENT_ID,
        'unique_internal_identifier' => cop['SerialNumber'],
        'last_name' => cop['LastName'],
        'first_name' => cop['GivenName1'],
        'middle_initial' => cop['GivenName2'],
        'gender' => cop['Gender'],
        'race' => cop['Ethnicity'],
        # 'rank' => BeverlyHills::Generator::Rank.get(cop['RankTile']).open_oversight_id,
        'star_no' => cop['BadgeNumber'],
        'job_title' => cop['job_title'],
        'salary_year' => cop['PayrollYear'],
        'salary_is_fiscal_year' => false,
        'salary' => cop['BasePay'],
        'overtime_pay' => cop['Overtime'],
      }
    end

    def filename
      'us/ca/police/beverly_hills/open_oversight.csv'
    end

    def page_template
      @page_template ||= File.read(page_template_path)
    end

    def page_template_path
      File.expand_path('./beverly_hills/open_oversight.csv', __dir__)
    end
  end
end
