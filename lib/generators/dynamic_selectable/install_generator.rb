module DynamicSelectable
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates',  __FILE__)

    def create_route_namespace
      inject_into_file 'config/routes.rb',
        "  namespace :dynamic_selectable do\n  end\n\n",
        after: "Rails.application.routes.draw do\n"
    end

    def create_parent_controller
      copy_file 'select_controller.rb', 'app/controllers/dynamic_selectable/select_controller.rb'
    end
  end
end
