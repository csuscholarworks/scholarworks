# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include BlacklightOaiProvider::SolrDocument

  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior

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

  use_extension( Hydra::ContentNegotiation )

  def date_submitted
    self[Solrizer.solr_name('date_submitted')]
  end

  def handle
    self[Solrizer.solr_name('handle')]
  end

  def handle_suffix
    self[Solrizer.solr_name('handle_suffix')]
  end

  def campus
    self[Solrizer.solr_name('campus')]
  end

  def college
    self[Solrizer.solr_name('college')]
  end

  def department
    self[Solrizer.solr_name('department')]
  end

  def degree_level
    self[Solrizer.solr_name('degree_level')]
  end

  def degree_name
    self[Solrizer.solr_name('degree_name')]
  end

  def abstract
    self[Solrizer.solr_name('abstract')]
  end

  def advisor
    self[Solrizer.solr_name('advisor')]
  end

  def committee_member
    self[Solrizer.solr_name('committee_member')]
  end

  def geographical_area
    self[Solrizer.solr_name('geographical_area')]
  end

  def time_period
    self[Solrizer.solr_name('time_period')]
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

  def sponsor
    self[Solrizer.solr_name('sponsor')]
  end

  def rights_access
    self[Solrizer.solr_name('rights_access')]
  end

  def alternative_title
    self[Solrizer.solr_name('alternative_title')]
  end

  def statement_of_responsibility
    self[Solrizer.solr_name('statement_of_responsibility')]
  end

  def publication_status
    self[Solrizer.solr_name('publication_status')]
  end

  def editor
    self[Solrizer.solr_name('editor')]
  end

  def bibliographic_citation
    self[Solrizer.solr_name('bibliographic_citation')]
  end

  def granting_institution
    self[Solrizer.solr_name('granting_institution')]
  end

  def rights_holder
    self[Solrizer.solr_name('rights_holder')]
  end

  # blacklight_oai_provider mapping
  field_semantics.merge!(
    contributor: ['contributor_tesim', 'advisor_tesim','committee_member_tesim','editor_tesim'],
    coverage: ['coverage_tesim', 'time_period_tesim', 'geographical_area_tesim'],
    creator: ['creator_tesim', 'author_tesim'],
    date: ['date_tesim','date_copyright_tesim'],
    description: ['description_tesim', 'abstract_tesim', 'publication_status_tesim', 'bibliographic_citation_tesim'],
    format: 'format',
    identifier: ['handle_tesim', 'identifier_tesim', 'doi_tesim', 'isbn_tesim', 'issn_tesim'],
    language: 'language_tesim',
    publisher: ['publisher_tesim','sponsor_tesim', 'college_tesim', 'department_tesim', 'granting_institution_tesim'],
    relation: 'relation_tesim',
    rights: ['rights_tesim', 'rights_statement_tesim', 'rights_note_tesim', 'rights_holder_tesim', 'rights_uri_tesim', 'license_tesim'],
    source: 'source_tesim',
    subject: ['subject_tesim', 'keyword_tesim'],
    title: ['title_tesim', 'alternative_title_tesim'],
    type: ['resource_type_tesim'],
    campus: ['campus_tesim']
  )
end
