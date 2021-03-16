require "rails_autolink/helpers"

module Hyrax
  module Renderers
    class CreatorAttributeRenderer < FacetedAttributeRenderer 

      attr_reader :extra_values

      # @param [Symbol] field
      # @param [Array] values
      # @param [Array] extra_values - extra values to display as text after each value
      # @param [Hash] options
      def initialize(field, values, extra_values, options = {})
        super(field, values, options)
        @extra_values = extra_values
      end
      
      # Draw the table row for the attribute
      def render
        markup = ''

        return markup if values.blank? && !options[:include_empty]
        markup << %(<tr><th>#{label}</th>\n<td><ul class='tabular'>)
        attributes = microdata_object_attributes(field).merge(class: "attribute attribute-#{field}")
        Array(values).each_with_index do |value, index|
          markup << "<li#{html_attributes(attributes)}>#{attribute_value_to_html(value.to_s, extra_values[0][index], extra_values[1][index], extra_values[2][index])}</li>"
        end
        markup << %(</ul></td></tr>)
        markup.html_safe
      end

      # Draw the dl row for the attribute
      def render_dl_row
        markup = ''
        return markup if values.blank? && !options[:include_empty]

        markup << %(<dt>#{label}</dt>\n<dd><ul class='tabular'>)
        attributes = microdata_object_attributes(field).merge(class: "attribute attribute-#{field}")
        Array(values).each_with_index do |value, index|
          markup << "<li#{html_attributes(attributes)}>#{attribute_value_to_html(value.to_s, extra_values[0][index], extra_values[1][index], extra_values[2][index])}</li>"
        end
        markup << %(</ul></dd>)
        markup.html_safe
      end

      private

        def attribute_value_to_html(value1, value2, value3, value4)
          if microdata_value_attributes(field).present?
            return_val = "<span#{html_attributes(microdata_value_attributes(field))}>#{li_value(value1)}</span>";
          else
            return_val = li_value(value1)
          end
          return_val += "&nbsp;<a href='mailto:#{value2}'><i class='fa fa-envelope' aria-hidden='true'></i> Email<span class='sr-only'> to author #{value1}</span></a>" unless value2.blank?
          return_val += "&nbsp;<a target='_blank' href='https://orcid.org/#{value3}'><img alt='ORCID profile for author #{value1}' class='profile' src='/assets/orcid-cb273c1ff10d304ce1b6108a172bfd1660561e7fd8133b083cd66ee0f4a0a944.png'></a>" unless value3.blank?
          return_val += "<span style='font-size: 12px'>&nbsp;#{value4}</span>" unless value4.blank?
          return_val
        end
    end
  end
end
