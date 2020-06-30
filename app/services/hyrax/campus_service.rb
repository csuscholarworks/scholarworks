# frozen_string_literal: true
module Hyrax

  # Provides essential methods for getting the normalized campus name
  #
  module CampusService
    CAMPUSES = [
      {
        name: 'Bakersfield',
        slug: 'bakersfield',
        email_domains: ['bakersfield.edu']
      },
      {
        name: 'Chancellor',
        slug: 'chancellor',
        email_domains: ['calstate.edu']
      },
      {
        name: 'Channel Islands',
        slug: 'channel',
        email_domains: ['ci.edu']
      },
      {
        name: 'Chico',
        slug: 'chico',
        email_domains: ['chico.edu']
      },
      {
        name: 'Dominguez Hills',
        slug: 'dominguez',
        email_domains: ['dh.edu']
      },
      {
        name: 'East Bay',
        slug: 'eastbay',
        email_domains: ['eb.edu']
      },
      {
        name: 'Fresno',
        slug: 'fresno',
        email_domains: ['fresno.edu']
      },
      {
        name: 'Fullerton',
        slug: 'fullerton',
        email_domains: ['fullerton.edu']
      },
      {
        name: 'Humboldt',
        slug: 'humboldt',
        email_domains: ['humboldt.edu']
      },
      {
        name: 'Long Beach',
        slug: 'longbeach',
        email_domains: ['lb.edu']
      },
      {
        name: 'Los Angeles',
        slug: 'losangeles',
        email_domains: ['la.edu']
      },
      {
        name: 'Maritime',
        slug: 'maritime',
        email_domains: ['csum.edu']
      },
      {
        name: 'Monterey Bay',
        slug: 'monterey',
        email_domains: ['csumb.edu']
      },
      {
        name: 'Moss Landing',
        slug: 'mlml',
        email_domains: ['mlml.edu']
      },
      {
        name: 'Northridge',
        slug: 'northridge',
        email_domains: ['csun.edu']
      },
      {
        name: 'Pomona',
        slug: 'pomona',
        email_domains: ['cpp.edu']
      },
      {
        name: 'Sacramento',
        slug: 'sacramento',
        email_domains: ['sacramento.edu']
      },
      {
        name: 'San Bernardino',
        slug: 'sacramento',
        email_domains: ['sacramento.edu']
      },
      {
        name: 'San Francisco',
        slug: 'sanfrancisco',
        email_domains: ['sf.edu']
      },
      {
        name: 'San Jose',
        slug: 'sanjose',
        email_domains: ['sjsu.edu']
      },
      {
        name: 'San Diego',
        slug: 'sandiego',
        email_domains: ['sdsu.edu']
      },
      {
        name: 'San Luis Obispo',
        slug: 'sanluisobisbo',
        email_domains: ['calpoly.edu']
      },
      {
        name: 'San Marcos',
        slug: 'sanmarcos',
        email_domains: ['sanmarcos.edu']
      },
      {
        name: 'Sonoma',
        slug: 'sonoma',
        email_domains: ['sonoma.edu']
      },
      {
        name: 'Stanislaus',
        slug: 'stanislaus',
        email_domains: ['stanislaus.edu']
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
        admin_set_name.include?(campus[:name])
      end

      raise 'No campus admin set found' unless result.present?

      result[:name]
    end
  end
end
