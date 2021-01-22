# Generated via
#  `rails generate hyrax:work Dataset`
module Hyrax
  # Generated form for Dataset
  class DatasetForm < Hyrax::Forms::WorkForm
    self.model_class = ::Dataset

    self.terms += [:resource_type_dataset, :sponsor, :date_issued, :alternative_title,
     :handle, :college, :department, :extent, :contributor, :geographical_area, :time_period,
     :rights_note, :rights_uri, :rights_holder, :doi, :oclcno, :issn, :isbn, :identifier_uri,
     :bibliographic_citation, :description, :description_note, :creator_email, :creator_orcid]

    self.terms -= [:handle, :source, :based_near, :location, :license,
      :date_created, :keyword, :extent]

    self.required_fields += [:creator, :title, :description, :resource_type_dataset, :rights_statement]

    self.required_fields -= [:keyword]

    def primary_terms
      [:creator, :title, :description, :resource_type_dataset, :rights_statement, :rights_holder, :rights_uri, :rights_note]
    end

    def secondary_terms
      [:alternative_title, :contributor, :publisher, :sponsor, :date_issued, :language,
       :related_url, :geographical_area, :time_period, :doi, :isbn, :issn, :oclcno, :identifier, :identifier_uri,
       :bibliographic_citation, :description_note]
    end
  end
end
