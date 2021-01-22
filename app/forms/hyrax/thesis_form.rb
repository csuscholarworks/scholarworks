# Generated via
#  `rails generate hyrax:work Thesis`
module Hyrax
  class ThesisForm < Hyrax::Forms::WorkForm
    self.model_class = ::Thesis
    self.terms += [:resource_type_thesis, :college, :department, :degree_level,
      :degree_name, :advisor, :committee_member, :date_issued, :subject,
      :alternative_title, :publisher, :time_period, :geographical_area,
      :identifier, :granting_institution, :rights_note, :rights_uri,
      :rights_holder, :doi, :oclcno, :issn, :isbn, :identifier_uri,
      :bibliographic_citation, :description_note, :creator_email, :creator_orcid]

    # remove these from parent workform
    self.terms -= [:contributor, :license, :date_created, :related_url, :source,
      :based_near, :keyword]

    # workform has :creator, :title, :rights_statement
    self.required_fields += [:description, :resource_type_thesis]
    # self.required_fields -= [:rights_statement]

    def primary_terms
      [:creator, :title, :description, :resource_type_thesis, :rights_statement]
    end

    def secondary_terms
      [:alternative_title, :advisor, :committee_member, :publisher, :college,
       :department, :degree_level, :degree_name, :date_issued, :subject,
       :language, :rights_holder, :rights_uri, :rights_note, :time_period,
       :geographical_area, :doi, :isbn, :issn, :oclcno, :identifier,
       :identifier_uri, :granting_institution, :bibliographic_citation,
       :description_note]
    end
  end
end
