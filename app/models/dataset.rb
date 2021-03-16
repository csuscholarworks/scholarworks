# Generated via
#  `rails generate hyrax:work Dataset`
class Dataset < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::CsuMetadata
  include ::Hydra::AccessControls::CampusVisibility
  before_create :update_fields

  self.indexer = DatasetIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  validates :creator, presence: { message: 'Your work must have an author.' }

  self.human_readable_type = 'Research Data'

  property :investigator, predicate: ::RDF::Vocab::MARCRelators.org do |index|
    index.as :stored_searchable
  end

  property :resource_type_dataset, predicate: ::RDF::Vocab::DC.type do |index|
    index.as :stored_searchable
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

  # this method is to combined all multivalues of this field into a single one for the front end
  def descriptions
    combined_val = ''
    description.each do |d|
      combined_val << d
    end
    combined_val
  end

  protected

  def update_fields
    super

    # assign main resource type from local resource type
    self.resource_type = resource_type_dataset
  end
end

