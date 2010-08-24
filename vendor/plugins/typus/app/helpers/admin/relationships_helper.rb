module Admin

  module RelationshipsHelper

    def setup_relationship(field)
      @field = field
      @model_to_relate = @resource.reflect_on_association(field.to_sym).class_name.constantize
      @model_to_relate_as_resource = @model_to_relate.to_resource
      @reflection = @resource.reflect_on_association(field.to_sym)
      @association = @reflection.macro
    end

    def typus_form_has_many(field)

      setup_relationship(field)

      foreign_key = @reflection.through_reflection ? @reflection.primary_key_name.pluralize : @reflection.primary_key_name

      @items_to_relate = @model_to_relate.send("find_all_by_#{foreign_key}", nil)
      if set_condition && !@items_to_relate.empty?
        form = build_relate_form
      end

      build_pagination
      options = { foreign_key => @item.id }

      render "admin/templates/has_n",
             :model_to_relate => @model_to_relate,
             :model_to_relate_as_resource => @model_to_relate_as_resource,
             :foreign_key => foreign_key,
             :add_new => raw(build_add_new(options)),
             :form => form,
             :table => build_relationship_table

    end

    def typus_form_has_and_belongs_to_many(field)

      setup_relationship(field)

      if @model_to_relate.count < 500
        @items_to_relate = (@model_to_relate.all - @item.send(field))
        if set_condition && !@items_to_relate.empty?
          form = build_relate_form
        end
      end

      build_pagination

      render "admin/templates/has_n",
             :model_to_relate => @model_to_relate,
             :model_to_relate_as_resource => @model_to_relate_as_resource,
             :add_new => raw(build_add_new),
             :form => form,
             :table => build_relationship_table

    end

    def build_pagination
      options = { :order => @model_to_relate.typus_order_by, :conditions => set_conditions }
      items_count = @resource.find(params[:id]).send(@field).count(:conditions => set_conditions)
      items_per_page = @model_to_relate.typus_options_for(:per_page)

      @pager = ::Paginator.new(items_count, items_per_page) do |offset, per_page|
        options.merge!({:limit => per_page, :offset => offset})
        items = @resource.find(params[:id]).send(@field).all(options)
      end

      @items = @pager.page(params[:page])
    end

    def build_relate_form
      render "admin/templates/relate_form",
             :model_to_relate => @model_to_relate,
             :items_to_relate => @items_to_relate
    end

    def build_relationship_table
      build_list(@model_to_relate,
                 @model_to_relate.typus_fields_for(:relationship),
                 @items,
                 @model_to_relate_as_resource,
                 {},
                 @association)
    end

    def build_add_new(options = {})
      default_options = { :controller => @field, :action => "new",
                          :resource => @resource.name, :resource_id => @item.id,
                          :back_to => @back_to }

      return unless set_condition && @current_user.can?("create", @model_to_relate)

      link_to _("Add new"), default_options.merge(options)
    end

    def set_condition
      if @resource.typus_user_id? && @current_user.is_not_root?
        @item.owned_by?(@current_user)
      else
        true
      end
    end

    def set_conditions
      if @model_to_relate.typus_options_for(:only_user_items) && @current_user.is_not_root?
        { Typus.user_fk => @current_user }
      end
    end

    #--
    # TODO: Move html code to partial.
    #++
    def typus_form_has_one(field)
      html = ""

      model_to_relate = @resource.reflect_on_association(field.to_sym).class_name.constantize
      model_to_relate_as_resource = model_to_relate.to_resource

      reflection = @resource.reflect_on_association(field.to_sym)
      association = reflection.macro

      html << <<-HTML
<a name="#{field}"></a>
<div class="box_relationships" id="#{model_to_relate_as_resource}">
  <h2>
  #{link_to model_to_relate.model_name.human, :controller => "admin/#{model_to_relate_as_resource}"}
  </h2>
      HTML
      items = Array.new
      items << @resource.find(params[:id]).send(field) unless @resource.find(params[:id]).send(field).nil?
      unless items.empty?
        options = { :back_to => @back_to, :resource => @resource.to_resource, :resource_id => @item.id }
        html << build_list(model_to_relate,
                           model_to_relate.typus_fields_for(:relationship),
                           items,
                           model_to_relate_as_resource,
                           options,
                           association)
      else
        message = _("There are no %{records}.",
                    :records => model_to_relate.model_name.human.downcase)
        html << <<-HTML
  <div id="flash" class="notice"><p>#{message}</p></div>
        HTML
      end
      html << <<-HTML
</div>
      HTML

      return html
    end

    def typus_belongs_to_field(attribute, form)

      ##
      # We only can pass parameters to 'new' and 'edit', so this hack makes
      # the work to replace the current action.
      #
      params[:action] = (params[:action] == 'create') ? 'new' : params[:action]

      back_to = url_for(:controller => params[:controller], :action => params[:action], :id => params[:id])

      related = @resource.reflect_on_association(attribute.to_sym).class_name.constantize
      related_fk = @resource.reflect_on_association(attribute.to_sym).primary_key_name

      confirm = [ _("Are you sure you want to leave this page?"),
                  _("If you have made any changes to the fields without clicking the Save/Update entry button, your changes will be lost."),
                  _("Click OK to continue, or click Cancel to stay on this page.") ]

      message = link_to _("Add"), { :controller => "admin/#{related.to_resource}",
                                    :action => 'new',
                                    :back_to => back_to,
                                    :selected => related_fk },
                                    :confirm => confirm.join("\n\n") if @current_user.can?('create', related)

      render "admin/templates/belongs_to",
             :resource => @resource,
             :form => form,
             :related_fk => related_fk,
             :message => message,
             :label_text => @resource.human_attribute_name(attribute),
             :values => related.all(:order => related.typus_order_by).collect { |p| [p.to_label, p.id] },
             # :html_options => { :disabled => attribute_disabled?(attribute) },
             :html_options => {},
             :options => { :include_blank => true }

    end

  end

end
