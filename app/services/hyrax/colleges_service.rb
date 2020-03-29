module Hyrax
  module CollegesService
    mattr_accessor :authority
    self.authority = Qa::Authorities::Local.subauthority_for('colleges')

    def self.select_options(admin_set_name)
      campus = Hyrax::CampusService.get_campus_from_admin_set(admin_set_name)
      campus.downcase!.sub!(' ', '_')
      campus_authority = Qa::Authorities::Local.subauthority_for('colleges_' + campus)

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
