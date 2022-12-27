# frozen_string_literal: true

module LaVerne
  class Generator < Jekyll::Generator
    attr_accessor :site

    def generate(site)
      @site = site

      cops.each do |cop|
        site.pages << CopPage.new(site, cop)
      end

      site.pages << OpenInsightCsv.new(site, cops)
    end

    def cops
      site.data['us']['ca']['police']['la_verne']['La_Verne_sworn_roster_2022-09-26']
    end
  end

  class CopPage < Jekyll::PageWithoutAFile
    def initialize(site, cop)
      @data = cop.merge(
        'layout' => 'page',
        'title' => "#{cop['LastName']}, #{cop['GivenName1']}"
      )
      @content = page_template

      super(site, __dir__, '', filename)
    end

    def filename
      "us/ca/police/la_verne/#{data['EmployeeId']}.html"
    end

    def page_template
      @page_template ||= File.read(page_template_path)
    end

    def page_template_path
      File.expand_path('./la_verne/cop.html', __dir__)
    end
  end

  class OpenInsightCsv < Jekyll::PageWithoutAFile
    attr_accessor :cops

    def initialize(site, cops)
      @content = page_template
      super(site, __dir__, '', filename)
    end

    def filename
      'us/ca/police/la_verne/open_oversight.csv'
    end

    def page_template
      @page_template ||= File.read(page_template_path)
    end

    def page_template_path
      File.expand_path('./la_verne/open_oversight.csv', __dir__)
    end
  end
end
