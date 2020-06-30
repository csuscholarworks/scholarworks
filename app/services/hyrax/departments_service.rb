module Hyrax
  module DepartmentsService
    mattr_accessor :authority
    self.authority = Qa::Authorities::Local.subauthority_for('departments')

    def self.select_options(controller, form)
      campus = Hyrax::CampusService.get_campus_from_form(controller, form)
      campus = campus.downcase.gsub(' ', '_')
      campus_authority = Qa::Authorities::Local.subauthority_for('departments_' + campus)

      campus_authority.all.map do |element|
        [element[:label], element[:id]]
      end
    end

    def self.label(id)
      authority.find(id).fetch('term')
    end

    ##
    # @param [String, nil] id identifier of the resource type
    #
    # @return [String] a schema.org type. Gives the default type if `id` is nil.
    def self.microdata_type(id)
      return Hyrax.config.microdata_default_type if id.nil?
      Microdata.fetch("resource_type_thesis.#{id}", default: Hyrax.config.microdata_default_type)
    end
  end
end
