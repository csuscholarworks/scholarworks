module Hydra
  module AccessControls
    module CampusVisibility

      def represented_visibility
        [Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED,
         Hyrax::CampusService.all_campus_slugs,
         Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC].flatten
      end

      def visibility=(value)
        super
      rescue ArgumentError => error
        raise error unless value.to_s == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_CAMPUS
        raise(RuntimeError, 'No campus is set on this work') if campus.blank?
        visibility_will_change! unless visibility == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_CAMPUS
        campus_slugs = campus.to_a.map { |campus_name| Hyrax::CampusService.get_campus_slug_from_name(campus_name) }
        remove_groups = represented_visibility - campus_slugs # read from object's campus value

        set_read_groups(campus_slugs, remove_groups)
      end

      def visibility
        original_value = super
        return original_value unless original_value == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE

        if read_groups_include_campus?
          Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_CAMPUS
        else
          original_value
        end
      end

      def read_groups_include_campus?
        read_groups&.any? do |read_group|
          campus&.any? do |campus_name|
            read_group == Hyrax::CampusService.get_campus_slug_from_name(campus_name)
          end
        end
      end
    end
  end
end
