# Generated via
#  `rails generate hyrax:work Thesis`
class Thesis < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::CsuMetadata
  include ::Hydra::AccessControls::CampusVisibility

  before_create :update_fields

  self.indexer = ThesisIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Student Work'

  property :advisor, predicate: ::RDF::Vocab::MARCRelators.ths do |index|
    index.as :stored_searchable, :facetable
  end

  property :committee_member, predicate: ::RDF::Vocab::MARCRelators.ctb do |index|
    index.as :stored_searchable, :facetable
  end

  property :degree_level, predicate: ::RDF::Vocab::DC.educationLevel, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :degree_name, predicate: ::RDF::Vocab::BIBO.degree do |index|
    index.as :stored_searchable, :facetable
  end

  property :granting_institution, predicate: ::RDF::Vocab::MARCRelators.uvp do |index|
    index.as :stored_searchable, :facetable
  end

  property :resource_type_thesis, predicate: ::RDF::Vocab::DC.type do |index|
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
    self.resource_type = resource_type_thesis
  end

end
