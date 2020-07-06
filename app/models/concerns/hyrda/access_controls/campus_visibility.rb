module Hydra::AccessControls
  module CampusVisibility

    def represented_visibility
      [Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED,
       'sanfrancisco', # need all campuses from CAMPUS list
       Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC]
    end

    def visibility=(value)
      super
    rescue ArgumentError => error
      raise error unless value == 'campus'
      visibility_will_change! unless visibility == 'campus'
      remove_groups = represented_visibility - ['sanfrancisco'] # read from object's campus value
      set_read_groups(['sanfrancisco'], remove_groups)
    end

    def visibility
      original_value = super
      return original_value unless original_value == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE

      if read_groups.include?('sanfrancisco') # from CAMPUS list
        'campus'
      else
        original_value
      end
    end
  end
end
