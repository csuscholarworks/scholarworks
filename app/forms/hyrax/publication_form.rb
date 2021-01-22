# Generated via
#  `rails generate hyrax:work Publication`
module Hyrax
  class PublicationForm < Hyrax::Forms::WorkForm
    self.model_class = ::Publication
    self.terms += [:resource_type_publication, :sponsor, :date_issued, :alternative_title,
      :publication_status, :editor, :description, :handle, :college, :department,
      :bibliographic_citation, :extent, :geographical_area, :time_period, :date_copyright,
      :rights_note, :rights_uri, :rights_holder, :doi, :oclcno, :issn, :isbn, :identifier_uri,
      :description_note, :creator_email, :creator_orcid]

    self.terms -= [:contributor, :date_created, :license, :based_near, :source, :handle,
      :keyword, :extent]

    self.required_fields += [:creator, :title, :description, :resource_type_publication,
      :college, :department, :date_issued]

    self.required_fields -= [:rights_statement, :keyword]

    def primary_terms
      [:creator, :title, :description, :resource_type_publication,
        :college, :department, :date_issued]
    end

    def secondary_terms
      [:alternative_title, :date_copyright, :editor, :publisher, :sponsor, :publication_status,
       :subject, :language, :rights_statement, :rights_holder, :rights_uri, :rights_note,
       :doi, :isbn, :issn, :oclcno, :identifier, :identifier_uri, :related_url,
       :bibliographic_citation, :description_note]
    end
  end
end
