# frozen_string_literal: true

module LosAngelesPolice
  class Generator < Jekyll::Generator
    attr_accessor :site

    def generate(site)
      @site = site

      cops.each do |cop|
        site.pages << CopPage.new(site, cop)
      end
    end

    def cops
      site.data['us']['ca']['police']['los_angeles']['cops']
    end
  end

  class CopPage < Jekyll::PageWithoutAFile
    def initialize(site, cop)
      @data = cop
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
end
