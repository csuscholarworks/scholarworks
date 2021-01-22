# Generated via
#  `rails generate hyrax:work EducationalResource`
module Hyrax
  class EducationalResourcePresenter < Hyrax::WorkShowPresenter

    delegate :date_submitted, :handle, :campus, :college, :department,
             :abstract, :geographical_area, :time_period, :date_available, :date_copyright,
             :date_issued, :sponsor, :alternative_title, :statement_of_responsibility,
             :creator_email, :creator_orcid, to: :solr_document

  end
end
