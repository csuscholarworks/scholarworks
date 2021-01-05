# Generated via
#  `rails generate hyrax:work EducationalResource`
class EducationalResource < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::CsuMetadata
  include ::Hydra::AccessControls::CampusVisibility

  before_create :update_fields

  self.indexer = EducationalResourceIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Educational Resource'

  property :resource_type_educational_resource, predicate: ::RDF::Vocab::DC.type do |index|
    index.as :stored_searchable, :facetable
  end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata

  def creator
    OrderedStringHelper.deserialize(super)
  end

  def creator= values
    super OrderedStringHelper.serialize(values)
  end

  protected

  def update_fields
    super
    
    # assign main resource type from local resource type
    self.resource_type = resource_type_educational_resource
  end
end
