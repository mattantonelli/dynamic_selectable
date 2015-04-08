module DynamicSelectable
  class SelectGenerator < Rails::Generators::Base
    argument :attributes, :type => :array, :default => [],
      :banner => "parent child value_method text_method [sort_col:asc/desc]"

    def create_route
      inject_into_file 'config/routes.rb', route(*attributes.first(2)), after: "namespace :select do\n"
    end

    def create_controller_file
      create_file controller_path(attributes[1]), controller_body(*attributes)
    end

    private
    def route(parent, child)
      children = child.pluralize
      "\t\tget ':#{parent}_id/#{children}', to: '#{children}#index', as: :#{children}\n"
    end

    def controller_path(child)
      "app/controllers/select/#{child.pluralize.underscore}_controller.rb"
    end

    def controller_body(parent, child, value_method, text_method, sort)
      children = child.pluralize
      <<-END
class Select::#{children.titleize.gsub(' ', '')}Controller < Select::SelectController
  def index
    #{children} = #{child.titleize.gsub(' ', '')}.where(#{parent}_id: params[:#{parent}_id]).select('#{value_method}, #{text_method}')#{sort.present? ? ".order('#{sort.gsub(':', ' ')}')" : ''}
    render json: #{children}
  end
end
      END
    end
  end
end
