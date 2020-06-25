# frozen_string_literal: true
module Hyrax

  # Provides essential methods for getting the normalized campus name
  #
  module CampusService
    CAMPUSES = [
      {
        name: 'Bakersfield',
        slug: 'bakersfield',
        email_domain: 'bakersfield.edu'
      },
      {
        name: 'Chancellor',
        slug: 'chancellor',
        email_domain: 'calstate.edu'
      },
      {
        name: 'Channel Islands',
        slug: 'channel',
        email_domain: 'ci.edu'
      },
      {
        name: 'Chico',
        slug: 'chico',
        email_domain: 'chico.edu'
      },
      {
        name: 'Dominguez Hills',
        slug: 'dominguez',
        email_domain: 'dh.edu'
      },
      {
        name: 'East Bay',
        slug: 'eastbay',
        email_domain: 'eb.edu'
      },
      {
        name: 'Fresno',
        slug: 'fresno',
        email_domain: 'fresno.edu'
      },
      {
        name: 'Fullerton',
        slug: 'fullerton',
        email_domain: 'fullerton.edu'
      },
      {
        name: 'Humboldt',
        slug: 'humboldt',
        email_domain: 'humboldt.edu'
      },
      {
        name: 'Long Beach',
        slug: 'longbeach',
        email_domain: 'lb.edu'
      },
      {
        name: 'Los Angeles',
        slug: 'losangeles',
        email_domain: 'la.edu'
      },
      {
        name: 'Maritime',
        slug: 'maritime',
        email_domain: 'csum.edu'
      },
      {
        name: 'Monterey Bay',
        slug: 'monterey',
        email_domain: 'csumb.edu'
      },
      {
        name: 'Moss Landing',
        slug: 'mlml',
        email_domain: 'mlml.edu'
      },
      {
        name: 'Northridge',
        slug: 'northridge',
        email_domain: 'csun.edu'
      },
      {
        name: 'Pomona',
        slug: 'pomona',
        email_domain: 'cpp.edu'
      },
      {
        name: 'Sacramento',
        slug: 'sacramento',
        email_domain: 'sacramento.edu'
      },
      {
        name: 'San Bernardino',
        slug: 'sacramento',
        email_domain: 'sacramento.edu'
      },
      {
        name: 'San Francisco',
        slug: 'sanfrancisco',
        email_domain: 'sf.edu'
      },
      {
        name: 'San Jose',
        slug: 'sanjose',
        email_domain: 'sjsu.edu'
      },
      {
        name: 'San Diego',
        slug: 'sandiego',
        email_domain: 'sdsu.edu'
      },
      {
        name: 'San Luis Obispo',
        slug: 'sanluisobisbo',
        email_domain: 'calpoly.edu'
      },
      {
        name: 'San Marcos',
        slug: 'sanmarcos',
        email_domain: 'sanmarcos.edu'
      },
      {
        name: 'Sonoma',
        slug: 'sonoma',
        email_domain: 'sonoma.edu'
      },
      {
        name: 'Stanislaus',
        slug: 'stanislaus',
        email_domain: 'stanislaus.edu'
      }
    ].freeze

    # Extract campus name from a form
    #
    # @param controller [ApplicationController] the current controller
    # @param form [Hyrax::Forms::WorkForm]      the current work form
    # @return [String] the campus name
    #
    def self.get_campus_from_form(controller, form)
      # if the record has a campus already, take that
      # because we are editing an existing record
      campus = form[:campus].first.to_s.dup
      return campus unless campus.empty?

      # otherwise get it from the admin set name
      # because we are creating a new record
      adminset = Hyrax::AdminSetService.new(controller).search_results(:deposit)
      campus = adminset.first.title_or_label.to_s
      get_campus_from_admin_set(campus)
    end

    # Extract campus name from Admin set
    #
    # @param admin_set_name [String] the admin sets public name
    # @return [String] the campus name
    #
    def self.get_campus_from_admin_set(admin_set_name)
      result = CAMPUSES.find do |campus|
        admin_set_name.include?(campus.name)
      end

      raise 'No campus admin set found' unless result.present?

      result
    end
  end
end
