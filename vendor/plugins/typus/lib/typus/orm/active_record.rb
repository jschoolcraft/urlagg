module Typus

  module Orm

    module ClassMethods

      # Model fields as an <tt>ActiveSupport::OrderedHash</tt>.
      def model_fields
        hash = ActiveSupport::OrderedHash.new
        columns.map { |u| hash[u.name.to_sym] = u.type.to_sym }
        return hash
      end

      # Model relationships as an <tt>ActiveSupport::OrderedHash</tt>.
      def model_relationships
        hash = ActiveSupport::OrderedHash.new
        reflect_on_all_associations.map { |i| hash[i.name] = i.macro }
        return hash
      end

      # Model description for admin panel.
      def typus_description
        Typus::Configuration.config[self.name]['description']
      end

      # Form and list fields
      def typus_fields_for(filter)

        fields_with_type = ActiveSupport::OrderedHash.new

        begin
          fields = Typus::Configuration.config[name]['fields'][filter.to_s]
          fields = fields.extract_settings.collect { |f| f.to_sym }
        rescue
          return [] if filter == 'default'
          filter = 'default'
          retry
        end

        begin

          fields.each do |field|

            attribute_type = model_fields[field]

            if reflect_on_association(field)
              attribute_type = reflect_on_association(field).macro
            end

            if typus_field_options_for(:selectors).include?(field)
              attribute_type = :selector
            end

            # Custom field_type depending on the attribute name.
            case field.to_s
              when 'parent', 'parent_id'  then attribute_type = :tree
              when /password/             then attribute_type = :password
              when 'position'             then attribute_type = :position
              when /\./                   then attribute_type = :transversal
            end

            if respond_to?(:attachment_definitions) && attachment_definitions.try(:has_key?, field)
              attribute_type = :file
            end

            # And finally insert the field and the attribute_type
            # into the fields_with_type ordered hash.
            fields_with_type[field.to_s] = attribute_type

          end

        rescue
          fields = Typus::Configuration.config[name]['fields']['default'].extract_settings
          retry
        end

        return fields_with_type

      end

      # Typus sidebar filters.
      def typus_filters

        fields_with_type = ActiveSupport::OrderedHash.new

        data = Typus::Configuration.config[name]['filters']
        return [] unless data
        fields = data.extract_settings.collect { |i| i.to_sym }

        fields.each do |field|
          attribute_type = model_fields[field.to_sym]
          if reflect_on_association(field.to_sym)
            attribute_type = reflect_on_association(field.to_sym).macro
          end
          fields_with_type[field.to_s] = attribute_type
        end

        return fields_with_type

      end

      def typus_actions
        return [] if Typus::Configuration.config[name]['actions'].nil?
        Typus::Configuration.config[name]['actions'].keys.map do |key|
          Typus::Configuration.config[name]['actions'][key].extract_settings
        end.flatten
      rescue
        []
      end

      # Extended actions for this model on Typus.
      def typus_actions_on(filter)
        Typus::Configuration.config[name]['actions'][filter.to_s].extract_settings
      rescue
        []
      end

      # Used for +search+, +relationships+
      def typus_defaults_for(filter)
        data = Typus::Configuration.config[name][filter.to_s]
        return (!data.nil?) ? data.extract_settings : []
      end

      def typus_search_fields
        data = Typus::Configuration.config[name]["search"]
        return [] if data.nil?

        search = {}

        data.extract_settings.each do |field|
          if field.starts_with?("=")
            field.slice!(0)
            search[field] = "="
          elsif field.starts_with?("^")
            field.slice!(0)
            search[field] = "^"
          else
            search[field] = "@"
          end
        end

        return search

      end

      #--
      # TODO: Test method.
      #++
      def typus_application
        Typus::Configuration.config[name]["application"] || "Unknown"
      end

      def typus_field_options_for(filter)
        Typus::Configuration.config[name]['fields']['options'][filter.to_s].extract_settings.collect { |i| i.to_sym }
      rescue
        []
      end

      #--
      # Options are defined for all resources on the initializer:
      #
      #     Typus::Resource.setup do |config|
      #       config.per_page = 15
      #     end
      #
      # But sometimes we need to define theme by model:
      #
      #     Post:
      #       ...
      #       options:
      #         per_page: 15
      #++
      def typus_options_for(filter)

        data = Typus::Configuration.config[name]
        unless data['options'].nil?
          value = data['options'][filter.to_s] unless data['options'][filter.to_s].nil?
        end

        return (!value.nil?) ? value : Typus::Resource.send(filter)

      end

      def typus_export_formats
        data = Typus::Configuration.config[name]
        !data['export'].nil? ? data['export'].extract_settings : []
      end

      # Used for `order_by`.
      def typus_order_by

        fields = typus_defaults_for(:order_by)

        if fields.empty?
          "#{table_name}.#{primary_key} ASC"
        else
          fields.map do |field|
            field.include?('-') ? "#{table_name}.#{field.delete('-')} DESC" : "#{table_name}.#{field} ASC"
          end.join(', ')
        end

      end

      #--
      # Define our own boolean mappings.
      #
      #     Post:
      #       fields:
      #         default: title, status
      #         options:
      #           booleans:
      #             status: "Published", "Not published"
      #
      #++
      def typus_boolean(attribute = :default)

        begin
          boolean = Typus::Configuration.config[name]['fields']['options']['booleans'][attribute.to_s]
        rescue
          boolean = 'true, false'
        end

        return nil if boolean.nil?

        hash = ActiveSupport::OrderedHash.new

        mapping = boolean.kind_of?(Array) ? boolean : boolean.extract_settings
        hash[:true], hash[:false] = mapping.first, mapping.last
        hash.map { |k, v| hash[k] = v.humanize }

        return hash

      end

      #--
      # Custom date formats.
      #++
      def typus_date_format(attribute = :default)
        Typus::Configuration.config[name]['fields']['options']['date_formats'][attribute.to_s].to_sym
      rescue
        :db
      end

      #--
      # This is user to use custome templates for attribute:
      #
      #     Post:
      #       fields:
      #         form: title, body, status
      #         options:
      #           templates:
      #             body: rich_text
      #
      # Templates are stored on <tt>app/views/admin/templates</tt>.
      #++
      def typus_template(attribute)
        Typus::Configuration.config[name]['fields']['options']['templates'][attribute.to_s]
      rescue
        nil
      end

      #--
      # Sidebar filters:
      #
      # - Booleans: true, false
      # - Datetime: today, last_few_days, last_7_days, last_30_days
      # - Integer & String: *_id and "selectors" (p.ej. category_id)
      #++
      def build_conditions(params)

        conditions, joins = merge_conditions, []

        query_params = params.dup
        %w(action controller).each { |param| query_params.delete(param) }

        # Remove from params those with empty string.
        query_params.delete_if { |k, v| v.empty? }

        # If a search is performed.
        if query_params[:search]
          query = ActiveRecord::Base.connection.quote_string(query_params[:search].downcase)
          search = []
          typus_search_fields.each do |key, value|
            _query = case value
                     when "=" then query
                     when "^" then "#{query}%"
                     when "@" then "%#{query}%"
                     end
            search << "#{key} LIKE '#{_query}'"
          end
          conditions = merge_conditions(conditions, search.join(" OR "))
        end

        query_params.each do |key, value|

          filter_type = model_fields[key.to_sym] || model_relationships[key.to_sym]

          case filter_type
          when :boolean
            condition = { key => (value == 'true') ? true : false }
            conditions = merge_conditions(conditions, condition)
          when :datetime
            interval = case value
                       when 'today'         then Time.new.midnight..Time.new.midnight.tomorrow
                       when 'last_few_days' then 3.days.ago.midnight..Time.new.midnight.tomorrow
                       when 'last_7_days'   then 6.days.ago.midnight..Time.new.midnight.tomorrow
                       when 'last_30_days'  then Time.new.midnight.prev_month..Time.new.midnight.tomorrow
                       end
            condition = ["#{key} BETWEEN ? AND ?", interval.first.to_s(:db), interval.last.to_s(:db)]
            conditions = merge_conditions(conditions, condition)
          when :date
            if value.is_a?(Hash)
              date_format = Date::DATE_FORMATS[typus_date_format(key)]

              begin
                unless value["from"].blank?
                  date_from = Date.strptime(value["from"], date_format)
                  conditions = merge_conditions(conditions, ["#{key} >= ?", date_from])
                end

                unless value["to"].blank?
                  date_to = Date.strptime(value["to"], date_format)
                  conditions = merge_conditions(conditions, ["#{key} <= ?", date_to])
                end
              rescue
              end
            else
              # TODO: Improve and test filters.
              interval = case value
                         when 'today'         then nil
                         when 'last_few_days' then 3.days.ago.to_date..Date.tomorrow
                         when 'last_7_days'   then 6.days.ago.midnight..Date.tomorrow
                         when 'last_30_days'  then (Date.today << 1)..Date.tomorrow
                         end
              if interval
                condition = ["#{key} BETWEEN ? AND ?", interval.first, interval.last]
              elsif value == 'today'
                condition = ["#{key} = ?", Date.today]
              end
              conditions = merge_conditions(conditions, condition)
            end
          when :integer, :string
            condition = { key => value }
            conditions = merge_conditions(conditions, condition)
          when :has_and_belongs_to_many
            condition = { key => { :id => value } }
            conditions = merge_conditions(conditions, condition)
            joins << key.to_sym
          end

        end

        return conditions, joins

      end

      def typus_user_id?
        columns.map { |u| u.name }.include?(Typus.user_fk)
      end

    end

    module InstanceMethods

      def owned_by?(user)
        send(Typus.user_fk) == user.id
      end

    end

  end

end

if defined?(ActiveRecord)
  ActiveRecord::Base.extend Typus::Orm::ClassMethods
  ActiveRecord::Base.send :include, Typus::Orm::InstanceMethods
end
