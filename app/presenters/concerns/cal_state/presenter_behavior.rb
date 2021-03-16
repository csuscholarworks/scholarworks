# frozen_string_literal: true

module CalState
  #
  # Presenter delegation for CSU metadata fields
  #
  module PresenterBehavior
    extend ActiveSupport::Concern
    included do
      delegate :abstract,
               :alternative_title,
               :campus,
               :college,
               :creator_email,
               :creator_orcid,
               :creator_institution,
               :date_accessioned,
               :date_available,
               :date_copyright,
               :date_issued,
               :date_submitted,
               :department,
               :description_note,
               :doi,
               :embargo_terms,
               :extent,
               :geographical_area,
               :handle,
               :identifier_uri,
               :issn,
               :isbn,
               :is_part_of,
               :license,
               :oclcno,
               :provenance,
               :rights_holder,
               :rights_note,
               :rights_uri,
               :sponsor,
               :statement_of_responsibility,
               :time_period, to: :solr_document
    end
  end
end
