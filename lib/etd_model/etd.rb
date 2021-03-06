module EtdModel
  class Etd < Dor::Abstract
    include Dor::Embargoable
    extend Deprecation
    
    has_many :parts, :property => :is_part_of, class_name: 'Part'
    has_many :supplemental_files, :property => :is_constituent_of, class_name: 'Part'
    has_many :permission_files, :property => :is_dependent_of, class_name: 'Part'

    has_metadata :name => 'properties', :type => ActiveFedora::SimpleDatastream, :versionable => false do |m|
      m.field 'name',  :string                    # PS:name
      m.field 'prefix', :string                   # PS:prefix
      m.field 'suffix', :string                   # PS:suffix
      m.field 'major', :string                    # PS:plan
      m.field 'degree', :string                   # PS:degree
      m.field 'advisor', :string                  # one of the readers?
      m.field 'etd_type', :string                 # PS:type
      m.field 'title', :string                    # PS:title
      m.field 'abstract', :text
      m.field 'containscopyright', :string
      m.field 'copyrightclearance', :string
      m.field 'sulicense', :string
      m.field 'cclicense', :string
      m.field 'cclicensetype', :string
      m.field 'embargo', :string
      m.field 'external_visibility', :string

      m.field 'term', :string
      m.field 'sub', :string

      m.field 'univid', :string                   # PS:univid
      m.field 'sunetid', :string                  # PS:sunetid
      m.field 'ps_career', :string                # PS:career
      m.field 'ps_program', :string               # PS:program
      m.field 'ps_plan', :string                  # PS:plan
      m.field 'ps_subplan', :string               # PS:subplan
      m.field 'dissertation_id', :string          # PS:dissertationid
      m.field 'provost', :string                  # PS:vpname

      # from latest ps revision
      m.field 'degreeconfyr', :string
      m.field 'schoolname', :string               # Display value derived from ps_career
      m.field 'department', :string               # Display value derived from ps_program
      m.field 'readerapproval', :string           # Possible Values: Not Submitted, Not Approved, Approved, Rejected, Reject with Modification
      m.field 'readercomment', :string
      m.field 'readeractiondttm', :string         # date?
      m.field 'regapproval', :string              # Possible Values: Not Submitted, Not Approved, Approved, Rejected, Reject with Modification
      m.field 'regcomment', :string
      m.field 'regactiondttm', :string
      m.field 'documentaccess', :string

      m.field 'submit_date', :string
      m.field 'symphonyStatus', :string
    end

    has_metadata :name => 'workflow', :type => ActiveFedora::SimpleDatastream, :versionable => false do |m|
      m.field 'citation_verified', :string
      m.field 'abstract_provided', :string
      m.field 'dissertation_uploaded', :string
      m.field 'supplemental_files_uploaded', :string
      m.field 'permissions_provided', :string
      m.field 'permission_files_uploaded', :string
      m.field 'rights_selected', :string
      m.field 'cc_license_selected', :string
      m.field 'submitted_to_registrar', :string
    end

    has_metadata :name => 'DC', type: Dor::SimpleDublinCoreDs, versionable: false, label: 'DC', control_group: 'X'

    def etd_embargo_date
      regaction = properties.regactiondttm.first
      embargo = properties.embargo.first
      if properties.regapproval.first =~ /^approved$/i &&
         !embargo.nil? && embargo != '' &&
         !regaction.nil? && regaction != ''
        case embargo
        when /6 months/i
          embargo_months = 6
        when /1 year/i
          embargo_months = 12
        when /2 years/i
          embargo_months = 24
        else
          embargo_months = 0
        end
        return Time.strptime(regaction, "%m/%d/%Y %H:%M:%S") + embargo_months.months
      end
      nil
    end

    alias get_embargo_date etd_embargo_date
    deprecation_deprecate get_embargo_date: "use etd_embargo_date instead"
  end
end
