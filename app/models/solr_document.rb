# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include BlacklightOaiProvider::SolrDocument

  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior

  include ::Hydra::AccessControls::CampusVisibility

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.

  use_extension(Hydra::ContentNegotiation)

  def abstract
    self[Solrizer.solr_name('abstract')]
  end

  def alternative_title
    self[Solrizer.solr_name('alternative_title')]
  end

  def advisor
    self[Solrizer.solr_name('advisor')]
  end

  def bibliographic_citation
    self[Solrizer.solr_name('bibliographic_citation')]
  end

  def campus
    self[Solrizer.solr_name('campus')]
  end

  def college
    self[Solrizer.solr_name('college')]
  end

  def committee_member
    self[Solrizer.solr_name('committee_member')]
  end

  def creator_email
    self[Solrizer.solr_name('creator_email')]
  end

  def creator_orcid
    self[Solrizer.solr_name('creator_orcid')]
  end

  def creator_institution
    self[Solrizer.solr_name('creator_institution')]
  end

  def date_accessioned
    self[Solrizer.solr_name('date_accessioned')]
  end

  def date_available
    self[Solrizer.solr_name('date_available')]
  end

  def date_copyright
    self[Solrizer.solr_name('date_copyright')]
  end

  def date_issued
    self[Solrizer.solr_name('date_issued')]
  end

  def date_submitted
    self[Solrizer.solr_name('date_submitted')]
  end

  def degree_level
    self[Solrizer.solr_name('degree_level')]
  end

  def degree_name
    self[Solrizer.solr_name('degree_name')]
  end

  def department
    self[Solrizer.solr_name('department')]
  end

  def description_note
    self[Solrizer.solr_name('description_note')]
  end

  def doi
    self[Solrizer.solr_name('doi')]
  end

  def editor
    self[Solrizer.solr_name('editor')]
  end

  def embargo_terms
    self[Solrizer.solr_name('embargo_terms')]
  end

  def extent
    self[Solrizer.solr_name('extent')]
  end

  def geographical_area
    self[Solrizer.solr_name('geographical_area')]
  end

  def granting_institution
    self[Solrizer.solr_name('granting_institution')]
  end

  def handle
    self[Solrizer.solr_name('handle')]
  end

  def handle_suffix
    self[Solrizer.solr_name('handle_suffix')]
  end

  def identifier_uri
    self[Solrizer.solr_name('identifier_uri')]
  end

  def investigator
    self[Solrizer.solr_name('investigator')]
  end

  def issn
    self[Solrizer.solr_name('issn')]
  end

  def isbn
    self[Solrizer.solr_name('isbn')]
  end

  def is_part_of
    self[Solrizer.solr_name('is_part_of')]
  end

  def license
    self[Solrizer.solr_name('license')]
  end

  def oclcno
    self[Solrizer.solr_name('oclcno')]
  end

  def provenance
    self[Solrizer.solr_name('provenance')]
  end

  def publication_status
    self[Solrizer.solr_name('publication_status')]
  end

  def rights_access
    self[Solrizer.solr_name('rights_access')]
  end

  def rights_holder
    self[Solrizer.solr_name('rights_holder')]
  end

  def rights_note
    self[Solrizer.solr_name('rights_note')]
  end

  def rights_uri
    self[Solrizer.solr_name('rights_uri')]
  end

  def sponsor
    self[Solrizer.solr_name('sponsor')]
  end

  def statement_of_responsibility
    self[Solrizer.solr_name('statement_of_responsibility')]
  end

  def time_period
    self[Solrizer.solr_name('time_period')]
  end

  # blacklight_oai_provider mapping
  field_semantics.merge!(
    contributor: %w[contributor_tesim advisor_tesim committee_member_tesim
                    editor_tesim],
    coverage: %w[coverage_tesim time_period_tesim geographical_area_tesim],
    creator: %w[creator_tesim author_tesim],
    date: %w[date_tesim date_copyright_tesim],
    description: %w[description_tesim abstract_tesim publication_status_tesim
                    bibliographic_citation_tesim],
    format: 'format',
    identifier: %w[handle_tesim identifier_tesim doi_tesim isbn_tesim
                   issn_tesim],
    language: 'language_tesim',
    publisher: %w[publisher_tesim sponsor_tesim college_tesim department_tesim
                  granting_institution_tesim],
    relation: 'relation_tesim',
    rights: %w[rights_tesim rights_statement_tesim rights_note_tesim
               rights_holder_tesim rights_uri_tesim license_tesim],
    source: 'source_tesim',
    subject: %w[subject_tesim keyword_tesim],
    title: %w[title_tesim alternative_title_tesim],
    type: %w[resource_type_tesim],
    campus: %w[campus_tesim]
  )
end
