module DynamicSelectable
  class Railtie < Rails::Railtie
    initializer 'dynamic_selectable.configure_form_options_helpers' do |app|
      ActiveSupport.on_load :action_view do
        include DynamicSelectable::ActionView::Helpers::DynamicFormOptionsHelper
      end
    end
  end
end
