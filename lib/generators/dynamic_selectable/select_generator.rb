module DynamicSelectable
  class SelectGenerator < Rails::Generators::Base
    argument :attributes, :type => :array, :default => [],
      :banner => "parent child value_method text_method [sort_col:asc/desc]"

    def create_route
      inject_into_file 'config/routes.rb', route(*attributes.first(2)), after: "namespace :dynamic_selectable do\n"
    end

    def create_controller_file
      create_file controller_path(attributes.second), controller_body(*attributes)
    end

    private
    def route(parent, child)
      children = child.pluralize
      "\t\tget ':#{parent}_id/#{children}', to: '#{children}#index', as: :#{children}\n"
    end

    def controller_path(child)
      "app/controllers/dynamic_selectable/#{child.pluralize.underscore}_controller.rb"
    end

    def controller_body(parent, child, val, text, sort)
      children = child.pluralize
      select_class = children.titleize.gsub(' ', '')
      child_class = child.titleize.gsub(' ', '')
      order = sort.present? ? ".order('#{sort.gsub(':', ' ')}')" : ''

      <<-END
module DynamicSelectable
  class #{select_class}Controller < SelectController
    def index
      #{children} = #{child_class}.where(#{parent}_id: params[:#{parent}_id]).select('#{val}, #{text}')#{order}
      render json: #{children}
    end
  end
end
      END
    end
  end
end
