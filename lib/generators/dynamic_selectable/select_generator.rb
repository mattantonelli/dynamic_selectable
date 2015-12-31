module DynamicSelectable
  class SelectGenerator < Rails::Generators::Base
    argument :attributes, :type => :array, :default => [],
      :banner => "parent child value_method text_method [sort_col:asc/desc]"

    def create_route
      inject_into_file 'config/routes.rb', route(*attributes.first(2)), after: "namespace :dynamic_selectable do\n"
    end

    def create_controller_file
      create_file controller_path(*attributes.first(2)), controller_body(*attributes)
    end

    private
    def route(parent, child)
      children = child.pluralize
      "    get '#{parent.pluralize}/:#{parent}_id/#{children}', to: '#{parent}_#{children}#index', as: :#{parent}_#{children}\n"
    end

    def controller_path(parent, child)
      "app/controllers/dynamic_selectable/#{parent}_#{child.pluralize.underscore}_controller.rb"
    end

    def controller_body(parent, child, val, text, sort)
      children = child.pluralize
      parent_class = parent.titleize.gsub(' ', '')
      select_class = children.titleize.gsub(' ', '')
      child_class  = child.titleize.gsub(' ', '')
      order = sort.present? ? ".order('#{sort.gsub(':', ' ')}')" : ''

      <<-END
module DynamicSelectable
  class #{parent_class}#{select_class}Controller < SelectController
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
