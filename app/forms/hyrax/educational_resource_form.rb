# Generated via
#  `rails generate hyrax:work EducationalResource`
module Hyrax
  # Generated form for EducationalResource
  class EducationalResourceForm < Hyrax::Forms::WorkForm
    self.model_class = ::EducationalResource

    self.terms += [:resource_type_educational_resource, :sponsor, :date_issued,
      :alternative_title, :handle, :college, :department, :contributor, :date_available,
      :date_created, :date_copyright, :identifier, :rights_note, :rights_uri, :rights_holder,
      :doi, :oclcno, :issn, :isbn, :identifier_uri, :bibliographic_citation, :license, :description,
      :extent, :description_note, :creator_email, :creator_orcid]

    self.terms -= [:handle, :based_near, :source, :date_available, :date_created, :keyword, :extent]

    self.required_fields += [:creator, :title, :description, :resource_type_educational_resource, :rights_statement]

    self.required_fields -= [:keyword]

    def primary_terms
      [:creator, :title, :description,
        :resource_type_educational_resource,
        :license, :rights_statement, :rights_holder, :rights_uri, :rights_note]
    end

    def secondary_terms
      [:alternative_title, :contributor, :publisher, :sponsor, :college, :department, :date_issued,
        :subject, :language, :related_url, :doi, :isbn, :issn, :oclcno, :identifier, :identifier_uri,
        :bibliographic_citation, :description_note]
    end
  end
end
