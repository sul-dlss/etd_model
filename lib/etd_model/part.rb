module EtdModel
  class Part < ActiveFedora::Base
    belongs_to :parents, :property => :is_part_of, class_name: 'Etd' # relationship between main pdf and parent etd
    belongs_to :supplemental_file_for, :property => :is_constituent_of, class_name: 'Etd' # relationship between supplemental file and parent etd
    belongs_to :permission_file_for, :property => :is_dependent_of, class_name: 'Etd'  # relationsihip between permission file and parent etd

    has_metadata :name => 'properties', :type => ActiveFedora::SimpleDatastream, :versionable => false do |m|
      m.field 'file_name', :string
      m.field 'size', :string
      m.field 'label', :string
    end

    has_metadata :name => 'DC', type: Dor::SimpleDublinCoreDs, versionable: false, label: 'DC', control_group: 'X'
  end
end
