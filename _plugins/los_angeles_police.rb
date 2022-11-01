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

      def self.register(code:, name:, open_oversight_id:)
        @@MAP[code] = Rank.new(name: name, open_oversight_id: open_oversight_id)
      end

      def self.get(code)
        raise "Unknown rank #{code}" if @@MAP[code].nil?

        @@MAP[code]
      end
    end

    Rank.register(code: 'COP', name: 'CHIEF OF POLICE', open_oversight_id: nil)
    Rank.register(code: 'AC', name: 'ASSITANT CHIEF', open_oversight_id: nil)
    # Rank.register(code: 'DEP CHF', name: 'POLICE DEPUTY CHIEF II', open_oversight_id: nil)
    # Rank.register(code: 'DEP CHF', name: 'POLICE DEPUTY CHIEF I', open_oversight_id: nil)
    Rank.register(code: 'DEP CHF', name: 'POLICE DEPUTY CHIEF', open_oversight_id: nil) # Roster doesn't distinguish between I and II
    Rank.register(code: 'MSGT', name: 'MUNICIPAL POLICE SERGEANT', open_oversight_id: nil)
    Rank.register(code: 'CMDR', name: 'POLICE COMMANDER', open_oversight_id: nil)
    # Rank.register(code: 'MCAPT 2', name: 'MUNICIPAL POLICE CAPTAIN II', open_oversight_id: nil)
    Rank.register(code: 'MCAPT 1', name: 'MUNICIPAL POLICE CAPTAIN I', open_oversight_id: nil)
    Rank.register(code: 'CAPT 3', name: 'POLICE CAPTAIN III', open_oversight_id: nil)
    Rank.register(code: 'CAPT 2', name: 'POLICE CAPTAIN II', open_oversight_id: nil)
    Rank.register(code: 'CAPT 1', name: 'POLICE CAPTAIN I', open_oversight_id: nil)
    Rank.register(code: 'LT 2', name: 'POLICE LIEUTENANT II', open_oversight_id: nil)
    Rank.register(code: 'LT 1', name: 'POLICE LIEUTENANT I', open_oversight_id: nil)
    Rank.register(code: 'DET 3', name: 'POLICE DETECTIVE III', open_oversight_id: nil)
    Rank.register(code: 'DET 2', name: 'POLICE DETECTIVE II', open_oversight_id: nil)
    Rank.register(code: 'DET 1', name: 'POLICE DETECTIVE I', open_oversight_id: nil)
    Rank.register(code: 'SGT 2', name: 'POLICE SERGEANT II', open_oversight_id: nil)
    Rank.register(code: 'SGT 1', name: 'POLICE SERGEANT I', open_oversight_id: nil)
    Rank.register(code: 'MPO', name: 'MUNICIPAL POLICE OFFICER', open_oversight_id: nil)
    Rank.register(code: 'PO 3', name: 'POLICE OFFICER III', open_oversight_id: nil)
    Rank.register(code: 'PO 2', name: 'POLICE OFFICER II', open_oversight_id: nil)
    Rank.register(code: 'PO 1', name: 'POLICE OFFICER I', open_oversight_id: nil)
    Rank.register(code: 'PO SPEC', name: 'POLICE SPECIALIST', open_oversight_id: nil)

    class Area
      @@MAP = {}

      attr_reader :name, :open_oversight_id

      def initialize(name:, open_oversight_id: nil)
        @name = name
        @open_oversight_id = open_oversight_id
      end

      def self.register(code:, name:, open_oversight_id:)
        @@MAP[code] = Area.new(name: name, open_oversight_id: open_oversight_id)
      end

      def self.get(code)
        raise "Unknown area #{code}" if @@MAP[code].nil?

        @@MAP[code]
      end
    end

    # Area definitions from https://cityfone.lacity.org/verity/department_directory/p030pol.pdf
    # and https://www.lapdonline.org/lapd-organization-chart/
    Area.register(code: '77TH', name: '77TH STREET AREA', open_oversight_id: nil)
    Area.register(code: 'AD', name: 'AUDIT DIVISION', open_oversight_id: nil)
    Area.register(code: 'ADSD', name: 'APPLICATION DEVELOPMENT AND SUPPORT DIVISION', open_oversight_id: nil)
    Area.register(code: 'ASB', name: 'ADMINISTRATIVE SERVICES BUREAU', open_oversight_id: nil)
    Area.register(code: 'ASD', name: 'AIR SUPPORT DIVISION', open_oversight_id: nil)
    Area.register(code: 'BSS', name: 'BEHAVIORAL SCIENCE SERVICES', open_oversight_id: nil)
    Area.register(code: 'CB', name: 'CENTRAL BUREAU', open_oversight_id: nil)
    Area.register(code: 'CCD', name: 'COMMERCIAL CRIMES DIVISION', open_oversight_id: nil)
    Area.register(code: 'CENT', name: 'CENTRAL AREA', open_oversight_id: nil)
    Area.register(code: 'CID', name: 'COMMISSION INVESTIGATION DIVISION', open_oversight_id: nil)
    Area.register(code: 'CIRD', name: 'CRITICAL INCIDENT REVIEW DIVISION', open_oversight_id: nil)
    Area.register(code: 'COMM', name: 'SUPPORT SERVICES GROUP Communications Division', open_oversight_id: nil)
    Area.register(code: 'COS', name: 'CHIEF OF STAFF', open_oversight_id: nil)
    Area.register(code: 'CP', name: 'OFFICE OF THE CHIEF OF POLICE', open_oversight_id: nil)
    Area.register(code: 'CSD', name: 'CUSTODY SERVICES DIVISION', open_oversight_id: nil)
    Area.register(code: 'CSPB', name: 'COMMUNITY SAFETY PARTNERSHIP BUREAU', open_oversight_id: nil)
    Area.register(code: 'CST', name: 'COMPSTAT DIVISION', open_oversight_id: nil)
    Area.register(code: 'CTD', name: 'CENTRAL TRAFFIC DIVISION', open_oversight_id: nil)
    Area.register(code: 'CTSOB', name: 'COUNTER-TERRORISM & SPECIAL OPERATIONS BUREAU', open_oversight_id: nil)
    Area.register(code: 'DB', name: 'DETECTIVE BUREAU', open_oversight_id: nil)
    Area.register(code: 'DEID', name: 'DIVERSITY EQUITY, AND INCLUSION DIVISION', open_oversight_id: nil)
    Area.register(code: 'DEIG', name: 'DIVERSITY, EQUITY, AND INCLUSION GROUP', open_oversight_id: nil)
    Area.register(code: 'DEV', name: 'DEVONSHIRE AREA', open_oversight_id: nil)
    Area.register(code: 'DSG', name: 'DETECTIVE SERVICES GROUP', open_oversight_id: nil)
    Area.register(code: 'DSVD', name: 'DETECTIVE SUPPORT AND VICE DIVISION', open_oversight_id: nil)
    Area.register(code: 'ECCCSD', name: 'EMERGENCY COMMAND CONTROL COMMUNICATIONS SYSTEM DIVISION', open_oversight_id: nil)
    Area.register(code: 'EPMD', name: 'EPMD', open_oversight_id: nil) # Unknown
    Area.register(code: 'ERG', name: 'EMPLOYEE RELATIONS GROUP', open_oversight_id: nil)
    Area.register(code: 'ESD', name: 'EMERGENCY SERVICES DIVISION', open_oversight_id: nil)
    Area.register(code: 'FID', name: 'FORCE INVESTIGATION DIVISION', open_oversight_id: nil)
    Area.register(code: 'FMD', name: 'FACILITIES MANAGEMENT DIVISION', open_oversight_id: nil)
    Area.register(code: 'FSD', name: 'FORENSIC SCIENCE DIVISION', open_oversight_id: nil)
    Area.register(code: 'FTHL', name: 'FOOTHILL AREA', open_oversight_id: nil)
    Area.register(code: 'GND', name: 'GANG AND NARCOTICS DIVISION', open_oversight_id: nil)
    Area.register(code: 'HARB', name: 'HARBOR AREA', open_oversight_id: nil)
    Area.register(code: 'HOBK', name: 'HOLLENBECK AREA', open_oversight_id: nil)
    Area.register(code: 'HWD', name: 'HOLLYWOOD AREA', open_oversight_id: nil)
    Area.register(code: 'IMD', name: 'INNOVATION MANAGEMENT DIVISION', open_oversight_id: nil)
    Area.register(code: 'IAD', name: 'INTERNAL AFFAIRS DIVISION', open_oversight_id: nil)
    Area.register(code: 'IG', name: 'IG', open_oversight_id: nil) # Unknown. Likely Office of the Inspector General
    Area.register(code: 'ITB', name: 'INFORMATION TECHNOLOGY BUREAU', open_oversight_id: nil)
    Area.register(code: 'ITD', name: 'INFORMATION TECHNOLOGY DIVISION', open_oversight_id: nil)
    Area.register(code: 'JUV', name: 'JUVENILE DIVISION', open_oversight_id: nil)
    Area.register(code: 'MCD', name: 'MAJOR CRIMES DIVISION', open_oversight_id: nil)
    Area.register(code: 'METRO', name: 'METROPOLITAN DIVISION', open_oversight_id: nil)
    Area.register(code: 'MISN', name: 'MISSION AREA', open_oversight_id: nil)
    Area.register(code: 'MRD', name: 'MEDIA RELATIONS DIVISION', open_oversight_id: nil)
    Area.register(code: 'NE', name: 'NORTHEAST AREA', open_oversight_id: nil)
    Area.register(code: 'NEWT', name: 'NEWTON AREA', open_oversight_id: nil)
    Area.register(code: 'NHWD', name: 'NORTH HOLLYWOOD AREA', open_oversight_id: nil)
    Area.register(code: 'OCPP', name: 'OFFICE OF CONSTITUTIONAL POLICING AND POLICY', open_oversight_id: nil)
    Area.register(code: 'OLYM', name: 'OLYMPIC AREA', open_oversight_id: nil)
    Area.register(code: 'OO', name: 'OFFICE OF OPERATIONS', open_oversight_id: nil)
    Area.register(code: 'OSO', name: 'OFFICE OF SPECIAL OPERATIONS', open_oversight_id: nil)
    Area.register(code: 'OSS', name: 'OFFICE OF SUPPORT SERVICES', open_oversight_id: nil)
    Area.register(code: 'PAC', name: 'PACIFIC AREA', open_oversight_id: nil)
    Area.register(code: 'PAC-LAX', name: 'PACIFIC AREA LAX Substation', open_oversight_id: nil)
    Area.register(code: 'PC', name: 'PC', open_oversight_id: nil) # Unknown. Likely Public Communications Group
    Area.register(code: 'PCG', name: 'PUBLIC COMMUNICATIONS GROUP', open_oversight_id: nil)
    Area.register(code: 'PER', name: 'PERSONNEL DIVISION', open_oversight_id: nil)
    Area.register(code: 'PER-M', name: 'PERSONNEL DIVISION Medical Liaison Section', open_oversight_id: nil) # Uncertain
    Area.register(code: 'PER-RW', name: 'PERSONNEL DIVISION Return to Work Section', open_oversight_id: nil) # Uncertain
    Area.register(code: 'PSB', name: 'PROFESSIONAL STANDARDS BUREAU', open_oversight_id: nil)
    Area.register(code: 'PTE', name: 'POLICE TRAINING AND EDUCATION', open_oversight_id: nil)
    Area.register(code: 'RAMP', name: 'RAMPART AREA', open_oversight_id: nil)
    Area.register(code: 'RED', name: 'RECRUITMENT AND EMPLOYMENT DIVISION', open_oversight_id: nil)
    Area.register(code: 'RHD', name: 'ROBBERY-HOMICIDE DIVISION', open_oversight_id: nil)
    Area.register(code: 'RMLAD', name: 'RISK MANAGEMENT AND LEGAL AFFAIRS DIVISION', open_oversight_id: nil)
    Area.register(code: 'SB', name: 'SOUTH BUREAU', open_oversight_id: nil)
    Area.register(code: 'SBHD', name: 'SOUTH BUREAU HOMICIDE DIVISION', open_oversight_id: nil)
    Area.register(code: 'SE', name: 'SOUTHEAST AREA', open_oversight_id: nil)
    Area.register(code: 'SECSD', name: 'SECURITY SERVICES DIVISION', open_oversight_id: nil)
    Area.register(code: 'SOD', name: 'SPECIAL OPERATIONS DIVISION', open_oversight_id: nil)
    Area.register(code: 'SSG', name: 'SUPPORT SERVICES GROUP', open_oversight_id: nil)
    Area.register(code: 'STD', name: 'SOUTH TRAFFIC DIVISION', open_oversight_id: nil)
    Area.register(code: 'SW', name: 'SOUTHWEST AREA', open_oversight_id: nil)
    Area.register(code: 'TD', name: 'TRAINING DIVISION', open_oversight_id: nil)
    Area.register(code: 'TD-REC', name: 'TD-REC', open_oversight_id: nil) # Unknown. Most likely recruits. Almost all are P01
    Area.register(code: 'TOP', name: 'TOPANGA AREA', open_oversight_id: nil)
    Area.register(code: 'TRB', name: 'TRAINING BUREAU', open_oversight_id: nil)
    Area.register(code: 'TRFG', name: 'TRAFFIC GROUP', open_oversight_id: nil)
    Area.register(code: 'TRSG', name: 'TRANSIT SERVICES GROUP', open_oversight_id: nil)
    Area.register(code: 'TSB', name: 'TRANSIT SERVICES BUREAU', open_oversight_id: nil)
    Area.register(code: 'TSD', name: 'TRANSIT SERVICES DIVISION', open_oversight_id: nil)
    Area.register(code: 'VB', name: 'VALLEY BUREAU', open_oversight_id: nil)
    Area.register(code: 'VNY', name: 'VAN NUYS AREA', open_oversight_id: nil)
    Area.register(code: 'VTD', name: 'VALLEY TRAFFIC DIVISION', open_oversight_id: nil)
    Area.register(code: 'WB', name: 'WEST BUREAU', open_oversight_id: nil)
    Area.register(code: 'WIL', name: 'WILSHIRE AREA', open_oversight_id: nil)
    Area.register(code: 'WLA', name: 'WEST LOS ANGELES AREA', open_oversight_id: nil)
    Area.register(code: 'WTD', name: 'WEST TRAFFIC DIVISION', open_oversight_id: nil)
    Area.register(code: 'WVAL', name: 'WEST VALLEY AREA', open_oversight_id: nil)

    def generate(site)
      @site = site
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
