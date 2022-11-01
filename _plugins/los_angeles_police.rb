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

    # Area definitions from https://cityfone.lacity.org/verity/department_directory/p030pol.pdf
    # and https://www.lapdonline.org/lapd-organization-chart/
    AREA_MAP = {
      '77TH' => '77TH STREET AREA',
      'AD' => 'AUDIT DIVISION',
      'ADSD' => 'APPLICATION DEVELOPMENT AND SUPPORT DIVISION',
      'ASB' => 'ADMINISTRATIVE SERVICES BUREAU',
      'ASD' => 'AIR SUPPORT DIVISION',
      'BSS' => 'BEHAVIORAL SCIENCE SERVICES',
      'CB' => 'CENTRAL BUREAU',
      'CCD' => 'COMMERCIAL CRIMES DIVISION',
      'CENT' => 'CENTRAL AREA',
      'CID' => 'COMMISSION INVESTIGATION DIVISION',
      'CIRD' => 'CRITICAL INCIDENT REVIEW DIVISION',
      'COMM' => 'SUPPORT SERVICES GROUP Communications Division',
      'COS' => 'CHIEF OF STAFF',
      'CP' => 'OFFICE OF THE CHIEF OF POLICE',
      'CSD' => 'CUSTODY SERVICES DIVISION',
      'CSPB' => 'COMMUNITY SAFETY PARTNERSHIP BUREAU',
      'CST' => 'COMPSTAT DIVISION',
      'CTD' => 'CENTRAL TRAFFIC DIVISION',
      'CTSOB' => 'COUNTER-TERRORISM & SPECIAL OPERATIONS BUREAU',
      'DB' => 'DETECTIVE BUREAU',
      'DEID' => 'DIVERSITY, EQUITY, AND INCLUSION DIVISION',
      'DEIG' => 'DIVERSITY, EQUITY, AND INCLUSION GROUP',
      'DEV' => 'DEVONSHIRE AREA',
      'DSG' => 'DETECTIVE SERVICES GROUP',
      'DSVD' => 'DETECTIVE SUPPORT AND VICE DIVISION',
      'ECCCSD' => 'EMERGENCY COMMAND CONTROL COMMUNICATIONS SYSTEM DIVISION',
      'EPMD' => 'EPMD', # Unknown
      'ERG' => 'EMPLOYEE RELATIONS GROUP',
      'ESD' => 'EMERGENCY SERVICES DIVISION',
      'FID' => 'FORCE INVESTIGATION DIVISION',
      'FMD' => 'FACILITIES MANAGEMENT DIVISION',
      'FSD' => 'FORENSIC SCIENCE DIVISION',
      'FTHL' => 'FOOTHILL AREA',
      'GND' => 'GANG AND NARCOTICS DIVISION',
      'HARB' => 'HARBOR AREA',
      'HOBK' => 'HOLLENBECK AREA',
      'HWD' => 'HOLLYWOOD AREA',
      'IMD' => 'INNOVATION MANAGEMENT DIVISION',
      'IAD' => 'INTERNAL AFFAIRS DIVISION',
      'IG' => 'IG', # Unknown. Likely Office of the Inspector General
      'ITB' => 'INFORMATION TECHNOLOGY BUREAU',
      'ITD' => 'INFORMATION TECHNOLOGY DIVISION',
      'JUV' => 'JUVENILE DIVISION',
      'MCD' => 'MAJOR CRIMES DIVISION',
      'METRO' => 'METROPOLITAN DIVISION',
      'MISN' => 'MISSION AREA',
      'MRD' => 'MEDIA RELATIONS DIVISION',
      'NE' => 'NORTHEAST AREA',
      'NEWT' => 'NEWTON AREA',
      'NHWD' => 'NORTH HOLLYWOOD AREA',
      'OCPP' => 'OFFICE OF CONSTITUTIONAL POLICING AND POLICY',
      'OLYM' => 'OLYMPIC AREA',
      'OO' => 'OFFICE OF OPERATIONS',
      'OSO' => 'OFFICE OF SPECIAL OPERATIONS',
      'OSS' => 'OFFICE OF SUPPORT SERVICES',
      'PAC' => 'PACIFIC AREA',
      'PAC-LAX' => 'PACIFIC AREA LAX Substation',
      'PC' => 'PC', # Unknown. Likely Public Communications Group
      'PCG' => 'PUBLIC COMMUNICATIONS GROUP',
      'PER' => 'PERSONNEL DIVISION',
      'PER-M' => 'PERSONNEL DIVISION Medical Liaison Section', # Uncertain
      'PER-RW' => 'PERSONNEL DIVISION Return to Work Section', # Uncertain
      'PSB' => 'PROFESSIONAL STANDARDS BUREAU',
      'PTE' => 'POLICE TRAINING AND EDUCATION',
      'RAMP' => 'RAMPART AREA',
      'RED' => 'RECRUITMENT AND EMPLOYMENT DIVISION',
      'RHD' => 'ROBBERY-HOMICIDE DIVISION',
      'RMLAD' => 'RISK MANAGEMENT AND LEGAL AFFAIRS DIVISION',
      'SB' => 'SOUTH BUREAU',
      'SBHD' => 'SOUTH BUREAU HOMICIDE DIVISION',
      'SE' => 'SOUTHEAST AREA',
      'SECSD' => 'SECURITY SERVICES DIVISION',
      'SOD' => 'SPECIAL OPERATIONS DIVISION',
      'SSG' => 'SUPPORT SERVICES GROUP',
      'STD' => 'SOUTH TRAFFIC DIVISION',
      'SW' => 'SOUTHWEST AREA',
      'TD' => 'TRAINING DIVISION',
      'TD-REC' => 'TD-REC', # Unknown. Most likely recruits. Almost all are P01
      'TOP' => 'TOPANGA AREA',
      'TRB' => 'TRAINING BUREAU',
      'TRFG' => 'TRAFFIC GROUP',
      'TRSG' => 'TRANSIT SERVICES GROUP',
      'TSB' => 'TRANSIT SERVICES BUREAU',
      'TSD' => 'TRANSIT SERVICES DIVISION',
      'VB' => 'VALLEY BUREAU',
      'VNY' => 'VAN NUYS AREA',
      'VTD' => 'VALLEY TRAFFIC DIVISION',
      'WB' => 'WEST BUREAU',
      'WIL' => 'WILSHIRE AREA',
      'WLA' => 'WEST LOS ANGELES AREA',
      'WTD' => 'WEST TRAFFIC DIVISION',
      'WVAL' => 'WEST VALLEY AREA',
    }.freeze

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
        raise "Unknown area #{cop['Area']}" if AREA_MAP[cop['Area']].nil?

        cop['area'] = AREA_MAP[cop['Area']]
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
