# frozen_string_literal: true

module SanJose
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
      site.data['us']['ca']['police']['san_jose']['roster-2022-09-26']
    end
  end

  class CopPage < Jekyll::PageWithoutAFile
    def initialize(site, cop)
      @data = cop.merge(
        'layout' => 'page',
        'title' => "#{cop['LastName']}, #{cop['FirstName']}"
      )
      @content = page_template

      super(site, __dir__, '', filename)
    end

    def filename
      "us/ca/police/san_jose/#{data['BadgeNumber']}.html"
    end

    def page_template
      @page_template ||= File.read(page_template_path)
    end

    def page_template_path
      File.expand_path('./san_jose/cop.html', __dir__)
    end
  end

  class OpenInsightCsv < Jekyll::PageWithoutAFile
    attr_accessor :cops

    def initialize(site, cops)
      @content = page_template
      super(site, __dir__, '', filename)
    end

    def filename
      'us/ca/police/san_jose/open_oversight.csv'
    end

    def page_template
      @page_template ||= File.read(page_template_path)
    end

    def page_template_path
      File.expand_path('./san_jose/open_oversight.csv', __dir__)
    end
  end
end
