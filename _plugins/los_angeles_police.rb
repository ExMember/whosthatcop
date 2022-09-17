# frozen_string_literal: true

module LosAngelesPolice
  class Generator < Jekyll::Generator
    def generate(site)
      @site = site

      cops = site.data['us']['ca']['police']['los_angeles']['cops']

      cops.each do |cop|
        site.pages << CopPage.new(site, cop)
      end
    end
  end

  class CopPage < Jekyll::PageWithoutAFile
    def initialize(site, cop)
      @data = cop
      @content = 'a cop page for <{{ page }}>'

      super(site, __dir__, '', filename)
    end

    def filename
      "us/ca/police/los_angeles/#{data['SerialNo']}.html"
    end
  end
end
