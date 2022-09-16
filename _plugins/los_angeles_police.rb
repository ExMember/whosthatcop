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
      super(site, __dir__, '', "us/ca/police/los_angeles/#{cop['SerialNo']}.html")
      @data = cop
      @content = 'a cop page for <{{ page }}>'
    end
  end
end
