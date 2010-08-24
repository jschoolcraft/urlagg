module Admin

  module TableHelper

    def build_table(model, fields, items, link_options = {}, association = nil)
      render "admin/helpers/table/table",
             :model => model,
             :fields => fields,
             :items => items,
             :link_options => link_options,
             :headers => table_header(model, fields)
    end

    def table_header(model, fields)
      fields.map do |key, value|

        key = key.gsub(".", " ") if key.match(/\./)
        content = model.human_attribute_name(key)

        if params[:action] == "index"
          association = model.reflect_on_association(key.to_sym)
          order_by = association ? association.primary_key_name : key

          if (model.model_fields.map(&:first).collect { |i| i.to_s }.include?(key) || model.reflect_on_all_associations(:belongs_to).map(&:name).include?(key.to_sym))
            sort_order = case params[:sort_order]
                         when 'asc' then ['desc', '&darr;']
                         when 'desc' then ['asc', '&uarr;']
                         else [nil, nil]
                         end
            switch = sort_order.last if params[:order_by].eql?(order_by)
            options = { :order_by => order_by, :sort_order => sort_order.first }
            message = [ content, switch ].compact
            link_to raw(message.join(" ")), params.merge(options)
          else
            content
          end

        else
          content
        end

      end
    end

    def table_fields_for_item(item, fields, link_options)
      fields.map do |key, value|
        case value
        when :boolean then table_boolean_field(key, item)
        when :datetime then table_datetime_field(key, item, link_options)
        when :date then table_datetime_field(key, item, link_options)
        when :file then table_file_field(key, item, link_options)
        when :time then table_datetime_field(key, item, link_options)
        when :belongs_to then table_belongs_to_field(key, item)
        when :tree then table_tree_field(key, item)
        when :position then table_position_field(key, item)
        when :selector then table_selector(key, item)
        when :transversal then table_transversal(key, item)
        when :has_and_belongs_to_many then table_has_and_belongs_to_many_field(key, item)
        else
          table_string_field(key, item, link_options)
        end
      end
    end

    def table_default_action(model, item)
      action = if model.typus_user_id? && @current_user.is_not_root?
                 # If there's a typus_user_id column on the table and logged user is not root ...
                 item.owned_by?(@current_user) ? item.class.typus_options_for(:default_action_on_item) : "show"
               elsif @current_user.cannot?("edit", model)
                 'show'
               else
                 item.class.typus_options_for(:default_action_on_item)
               end

      options = { :controller => "admin/#{item.class.to_resource}",
                  :action => action,
                  :id => item.id }

      link_to _(action.capitalize), options
    end

    #--
    # This controls the action to perform. If we are on a model list we
    # will remove the entry, but if we inside a model we will remove the
    # relationship between the models.
    #
    # Only shown is the user can destroy/unrelate items.
    #++
    def table_action(model, item)

      condition = true

      case params[:action]
      when "index"
        action = "trash"
        options = { :action => 'destroy', :id => item.id }
        method = :delete
      when "edit", "show"
        action = "unrelate"
        options = { :action => 'unrelate', :id => params[:id], :resource => model, :resource_id => item.id }
      end

      title = _(action.titleize)

      case params[:action]
      when 'index'
        condition = if model.typus_user_id? && @current_user.is_not_root?
                      item.owned_by?(@current_user)
                    elsif (@current_user.id.eql?(item.id) && model.eql?(Typus.user_class))
                      false
                    else
                      @current_user.can?('destroy', model)
                    end
        confirm = _("Remove %{resource}?", :resource => item.class.model_name.human)
      when 'edit'
        # If we are editing content, we can relate and unrelate always!
        confirm = _("Unrelate %{unrelate_model} from %{unrelate_model_from}?",
                    :unrelate_model => model.model_name.human,
                    :unrelate_model_from => @resource.model_name.human)
      when 'show'
        # If we are showing content, we only can relate and unrelate if we are
        # the owners of the owner record.
        # If the owner record doesn't have a foreign key (Typus.user_fk) we look
        # each item to verify the ownership.
        condition = if @resource.typus_user_id? && @current_user.is_not_root?
                      @item.owned_by?(@current_user)
                    end
        confirm = _("Unrelate %{unrelate_model} from %{unrelate_model_from}?",
                    :unrelate_model => model.model_name.human,
                    :unrelate_model_from => @resource.model_name.human)
      end

      message = %(<div class="sprite #{action}">#{action.titleize}</div>)

      if condition
        link_to raw(message), options, :title => title, :confirm => confirm, :method => method
      end

    end

    def table_belongs_to_field(attribute, item)
      att_value = item.send(attribute)
      content = "&mdash;".html_safe

      unless att_value.nil?
        content = att_value.to_label
        action = item.send(attribute).class.typus_options_for(:default_action_on_item)
        if @current_user.can?(action, att_value.class.name)
          content = link_to content, :controller => "admin/#{att_value.class.to_resource}", :action => action, :id => att_value.id
        end
      end

      return content_tag(:td, content)
    end

    def table_has_and_belongs_to_many_field(attribute, item)
      content = item.send(attribute).map { |i| i.to_label }.join(", ")
      return content_tag(:td, content)
    end

    def table_string_field(attribute, item, link_options = {})
      raw_content = item.send(attribute)
      content = raw_content.blank? ? "&#151;".html_safe : raw_content
      return content_tag(:td, content, :class => attribute)
    end

    def table_selector(attribute, item)
      raw_content = item.mapping(attribute)
      return content_tag(:td, raw_content, :class => attribute)
    end

    def table_file_field(attribute, item, link_options = {})
      file_preview = Typus.file_preview
      file_thumbnail = Typus.file_thumbnail

      has_file_preview = item.send(attribute).styles.member?(file_preview)
      file_preview_is_image = item.send("#{attribute}_content_type") =~ /^image\/.+/

      content = if has_file_preview && file_preview_is_image
                  render "admin/helpers/preview",
                         :attribute => attribute,
                         :attachment => attribute,
                         :content => item.send(attribute),
                         :file_preview_is_image => file_preview_is_image,
                         :has_file_preview => has_file_preview,
                         :href => item.send(attribute).url(file_preview),
                         :item => item
                else
                  link_to item.send(attribute), item.send(attribute).url
                end

      return content_tag(:td, content)
    end

    def table_tree_field(attribute, item)
      content = item.parent ? item.parent.to_label : "&#151;".html_safe
      return content_tag(:td, content)
    end

    def table_position_field(attribute, item)
      html_position = []

      { :move_higher => "Up", :move_lower => "Down" }.each do |key, value|
        options = { :controller => item.class.to_resource, :action => "position", :id => item.id, :go => key }
        first_or_last = (item.respond_to?(:first?) && (key == :move_higher && item.first?)) || (item.respond_to?(:last?) && (key == :move_lower && item.last?))
        html_position << link_to_unless(first_or_last, _(value), params.merge(options)) do |name|
          %(<span class="inactive">#{name}</span>)
        end
      end

      content = html_position.join(" / ").html_safe
      return content_tag(:td, content)
    end

    def table_datetime_field(attribute, item, link_options = {} )
      date_format = item.class.typus_date_format(attribute)
      content = !item.send(attribute).nil? ? item.send(attribute).to_s(date_format) : item.class.typus_options_for(:nil)

      return content_tag(:td, content)
    end

    def table_boolean_field(attribute, item)
      boolean_hash = item.class.typus_boolean(attribute)
      status = item.send(attribute)

      content = if status.nil?
                  Typus::Resource.human_nil
                else
                  message = _(boolean_hash["#{status}".to_sym])
                  options = { :controller => "admin/#{item.class.to_resource}",
                              :action => "toggle",
                              :id => item.id,
                              :field => attribute.gsub(/\?$/,'') }
                  confirm = _("Change %{attribute}?",
                              :attribute => item.class.human_attribute_name(attribute).downcase)
                  link_to message, options, :confirm => confirm
                end

      return content_tag(:td, content)
    end

    def table_transversal(attribute, item)
      _attribute, virtual = attribute.split(".")
      return content_tag(:td, item.send(_attribute).send(virtual))
    end

  end

end
