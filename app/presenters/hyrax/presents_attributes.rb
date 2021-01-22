module Hyrax
  module PresentsAttributes
    ##
    # Present the attribute as an HTML table row or dl row.
    #
    # @param [Hash] options
    # @option options [Symbol] :render_as use an alternate renderer
    #   (e.g., :linked or :linked_attribute to use LinkedAttributeRenderer)
    # @option options [String] :search_field If the method_name of the attribute is different than
    #   how the attribute name should appear on the search URL,
    #   you can explicitly set the URL's search field name
    # @option options [String] :label The default label for the field if no translation is found
    # @option options [TrueClass, FalseClass] :include_empty should we display a row if there are no values?
    # @option options [String] :work_type name of work type class (e.g., "GenericWork")
    def attribute_to_html(field, options = {})
      unless respond_to?(field)
        Rails.logger.warn("#{self.class} attempted to render #{field}, but no method exists with that name.")
        return
      end

      values = send(field)
      if options[:render_as].to_s == 'creator'
        creator_email = assign_creator_info(send(:creator_email), values.size)
        creator_orcid = assign_creator_info(send(:creator_orcid), values.size)
        extra_values = [creator_email, creator_orcid]
        creator_renderer = Hyrax::Renderers::CreatorAttributeRenderer.new(field, values, extra_values, options)
        if options[:html_dl]
          creator_renderer.render_dl_row
        else
          creator_renderer.render
        end
      else
        if options[:html_dl]
          renderer_for(field, options).new(field, values, options).render_dl_row
        else
          renderer_for(field, options).new(field, values, options).render
        end
      end
    end

    def permission_badge
      permission_badge_class.new(solr_document.visibility).render
    end

    def permission_badge_class
      PermissionBadge
    end

    def display_microdata?
      Hyrax.config.display_microdata?
    end

    def microdata_type_to_html
      return "" unless display_microdata?
      value = Microdata.fetch(microdata_type_key, default: Hyrax.config.microdata_default_type)
      " itemscope itemtype=\"#{value}\"".html_safe
    end

    private

      def find_renderer_class(name)
        renderer = nil
        ['Renderer', 'AttributeRenderer'].each do |suffix|
          const_name = "#{name.to_s.camelize}#{suffix}".to_sym
          renderer = begin
            Renderers.const_get(const_name)
          rescue NameError
            nil
          end
          break unless renderer.nil?
        end
        raise NameError, "unknown renderer type `#{name}`" if renderer.nil?
        renderer
      end

      def renderer_for(_field, options)
        if options[:render_as]
          find_renderer_class(options[:render_as])
        else
          Renderers::AttributeRenderer
        end
      end

      def microdata_type_key
        "resource_type.#{human_readable_type}"
      end

      def assign_creator_info(creator_info, creator_size)
        ret_arr = Array.new(creator_size, '')
        return ret_arr if creator_info.nil?

        ret_arr.each_with_index do |a, i|
          ret_arr[i] = creator_info[i] if !creator_info[i].nil?
        end
        ret_arr
      end
  end
end
