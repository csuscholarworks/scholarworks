# Generated via
#  `rails generate hyrax:work FacultyWork`
module CsuMetadata
  extend ActiveSupport::Concern

  included do

    property :abstract, predicate: ::RDF::Vocab::DC.abstract do |index|
      index.as :stored_searchable, :facetable
    end

    property :alternative_title, predicate: ::RDF::Vocab::DC.alternative do |index|
      index.as :stored_searchable, :facetable
    end

    property :campus, predicate: ::RDF::Vocab::DC.publisher do |index|
      index.as :stored_searchable, :facetable
    end

    property :college, predicate: ::RDF::Vocab::SCHEMA.CollegeOrUniversity do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_available, predicate: ::RDF::Vocab::DC.available do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_copyright, predicate: ::RDF::Vocab::DC.dateCopyrighted do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_issued, predicate: ::RDF::Vocab::DC.issued do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_submitted, predicate: ::RDF::Vocab::DC.date do |index|
      index.as :stored_searchable, :facetable
    end

    property :department, predicate: ::RDF::Vocab::SCHEMA.department do |index|
      index.as :stored_searchable, :facetable
    end

    property :extent, predicate: ::RDF::Vocab::DC.extent do |index|
      index.as :stored_searchable, :facetable
    end

    property :geographical_area, predicate: ::RDF::Vocab::DC.spatial do |index|
      index.as :stored_searchable, :facetable
    end

    property :handle, predicate: ::RDF::Vocab::PREMIS.ContentLocation do |index|
      index.as :stored_searchable, :facetable
    end

    property :is_part_of, predicate: ::RDF::Vocab::DC.relation do |index|
      index.as :stored_searchable, :facetable
    end

    property :license, predicate: ::RDF::Vocab::DC.license do |index|
      index.as :stored_searchable, :facetable
    end

    property :rights_holder, predicate: ::RDF::Vocab::DC.rightsHolder do |index|
      index.as :stored_searchable, :facetable
    end

    property :rights_note, predicate: ::RDF::Vocab::DC.rights do |index|
      index.as :stored_searchable, :facetable
    end

    property :rights_uri, predicate: ::RDF::URI.new('http://purl.org/dc/terms/rights'), multiple: true

    property :sponsor, predicate: ::RDF::Vocab::MARCRelators.spn do |index|
      index.as :stored_searchable, :facetable
    end

    property :statement_of_responsibility, predicate: ::RDF::Vocab::MARCRelators.rpy do |index|
      index.as :stored_searchable, :facetable
    end

    property :time_period, predicate: ::RDF::Vocab::DC.temporal do |index|
      index.as :stored_searchable, :facetable
    end

    property :provenance, predicate: ::RDF::Vocab::DC.provenance
    property :date_accessioned, predicate: ::RDF::Vocab::DC.date, multiple: false
    property :embargo_terms, predicate: ::RDF::Vocab::DC.description, multiple: false
  end

  protected

  def update_fields

    # assign campus name based on admin set
    campus = Hyrax::CampusService.get_campus_from_admin_set(admin_set.title.first.to_s)
    self.campus = [campus]
  end

end
