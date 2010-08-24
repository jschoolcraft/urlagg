module Admin

  module FormHelper

    def build_form(fields, form)
      html = ""

      fields.each do |key, value|

        if template = @resource.typus_template(key)
          html << typus_template_field(key, template, form)
          next
        end

        html << case value
                when :belongs_to
                  typus_belongs_to_field(key, form)
                when :tree
                  typus_tree_field(key, form)
                when :boolean, :date, :datetime, :string, :text, :time,
                     :file, :password, :selector
                  typus_template_field(key, value, form)
                else
                  typus_template_field(key, :string, form)
                end
      end

      return html
    end

    def form_partial
      resource = @resource.to_resource
      template_file = Rails.root.join("app/views/admin/#{resource}/_form.html.erb")
      partial = File.exists?(template_file) ? resource : "resources"

      return "admin/#{partial}/form"
    end

    def typus_tree_field(attribute, form)
      render "admin/templates/tree",
             :attribute => attribute,
             :form => form,
             :label_text => @resource.human_attribute_name(attribute),
             :values => expand_tree_into_select_field(@resource.roots, "parent_id")
    end

    # OPTIMIZE: Cleanup the case statement.
    def typus_relationships

      @back_to = url_for(:controller => params[:controller], :action => params[:action], :id => params[:id])

      html = ""

      @resource.typus_defaults_for(:relationships).each do |relationship|

        association = @resource.reflect_on_association(relationship.to_sym)

        next if @current_user.cannot?('read', association.class_name.constantize)

        case association.macro
        when :has_and_belongs_to_many
          html << typus_form_has_and_belongs_to_many(relationship)
        when :has_many
          if association.options[:through]
            # Here we will shot the relationship. Better this than raising an error.
          else
            html << typus_form_has_many(relationship)
          end
        when :has_one
          html << typus_form_has_one(relationship)
        end

      end

      return html

    end

    def typus_template_field(attribute, template, form)

      options = { :start_year => @resource.typus_options_for(:start_year),
                  :end_year => @resource.typus_options_for(:end_year),
                  :minute_step => @resource.typus_options_for(:minute_step),
                  # :disabled => attribute_disabled?(attribute),
                  :include_blank => true }

      render "admin/templates/#{template}",
             :resource => @resource,
             :attribute => attribute,
             :options => options,
             :html_options => {},
             :form => form,
             :label_text => @resource.human_attribute_name(attribute)

    end

=begin
    def attribute_disabled?(attribute)
      accessible = @resource.accessible_attributes
      return accessible.nil? ? false : !accessible.include?(attribute)
    end
=end

    ##
    # Tree builder when model +acts_as_tree+
    #
    def expand_tree_into_select_field(items, attribute)
      html = ""

      items.each do |item|
        html << %{<option #{"selected" if @item.send(attribute) == item.id} value="#{item.id}">#{"&nbsp;" * item.ancestors.size * 2} &#8627; #{item.to_label}</option>\n}
        html << expand_tree_into_select_field(item.children, attribute) unless item.children.empty?
      end

      return html
    end

  end

end
