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

    property :date_submitted, predicate: ::RDF::Vocab::SCHEMA.Date do |index|
      index.as :stored_searchable, :facetable
    end

    property :department, predicate: ::RDF::Vocab::SCHEMA.department do |index|
      index.as :stored_searchable, :facetable
    end

    property :description_note, predicate: ::RDF::Vocab::SCHEMA.description do |index|
      index.as :stored_searchable, :facetable
    end

    property :doi, predicate: ::RDF::Vocab::SCHEMA.identifier, multiple: true

    property :extent, predicate: ::RDF::Vocab::DC.extent do |index|
      index.as :stored_searchable, :facetable
    end

    property :geographical_area, predicate: ::RDF::Vocab::DC.spatial do |index|
      index.as :stored_searchable, :facetable
    end

    property :handle, predicate: ::RDF::Vocab::PREMIS.ContentLocation do |index|
      index.as :stored_searchable, :facetable
    end

    property :identifier_uri, predicate: ::RDF::URI.new('http://id.loc.gov/vocabulary/identifiers/uri'), multiple: true

    property :issn, predicate: ::RDF::Vocab::SCHEMA.issn, multiple: true

    property :isbn, predicate: ::RDF::Vocab::SCHEMA.isbn, multiple: true

    property :is_part_of, predicate: ::RDF::Vocab::DC.relation do |index|
      index.as :stored_searchable, :facetable
    end

    property :license, predicate: ::RDF::Vocab::DC.license do |index|
      index.as :stored_searchable, :facetable
    end

    property :oclcno, predicate: ::RDF::Vocab::BIBO.oclcnum, multiple: true

    property :rights_holder, predicate: ::RDF::Vocab::DC.rightsHolder do |index|
      index.as :stored_searchable, :facetable
    end

    property :rights_note, predicate: ::RDF::Vocab::EBUCore.rightsExpression do |index|
      index.as :stored_searchable, :facetable
    end

    property :rights_uri, predicate: ::RDF::URI.new('http://purl.org/dc/elements/1.1/rights'), multiple: true

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

    property :creator_email, predicate: ::RDF::Vocab::VCARD.hasEmail, multiple: true do |index|
      index.as :stored_searchable
    end

    property :creator_orcid, predicate: ::RDF::Vocab::VCARD.hasUID, multiple: true do |index|
      index.as :stored_searchable
    end

    validates_with CreatorOrcidValidator
    
    def creator_email
      return [] if super.nil?
      
      return OrderedStringHelper.deserialize(super)
    end

    def creator_email= values
      full_sanitizer = Rails::Html::FullSanitizer.new
      sanitized_values = Array.new(values.size, '')
      values.each_with_index do |v, i|
        if (v != '|||')
          sanitized_values[i] = full_sanitizer.sanitize(v)
        end
      end
      super OrderedStringHelper.serialize(sanitized_values)
    end

    def creator_orcid
      return [] if super.nil?

      return OrderedStringHelper.deserialize(super)
    end
    
    def creator_orcid= values
      full_sanitizer = Rails::Html::FullSanitizer.new
      sanitized_values = Array.new(values.size, '')
      values.each_with_index do |v, i|
        if (v != '|||')
          sanitized_values[i] = full_sanitizer.sanitize(v)
        end
      end
      super OrderedStringHelper.serialize(sanitized_values)
    end

  end

  def handle_suffix
    return nil if handle.blank?

    handle.map{ |url| url.split('/')[-1]}
  end

  def assign_campus(admin_set_title)
    # assign campus name based on admin set
    campus = Hyrax::CampusService.get_campus_from_admin_set(admin_set_title)
    self.campus = [campus]
  end

  protected

  def update_fields
    raise 'No admin set defined for this item.' if admin_set&.title&.first.nil?

    assign_campus(admin_set.title.first.to_s)
  end

end
