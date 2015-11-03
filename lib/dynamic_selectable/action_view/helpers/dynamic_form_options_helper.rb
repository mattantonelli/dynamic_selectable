module DynamicSelectable
  module ActionView
    module Helpers
      module DynamicFormOptionsHelper
        def dynamic_collection_select(object, method, dynamic_model, collection, value_method, text_method,
                                      options = {}, html_options = {})
          select_url    = "dynamic_selectable_#{dynamic_model.to_s.pluralize}_path"
          parent_id     = ":#{method}"
          select_target = "##{object}_#{dynamic_model}_id"

          data_options = { data: { dynamic_selectable_url: send(select_url, parent_id),
                                   dynamic_selectable_target: select_target } }

          collection_select(nil, nil, collection, value_method, text_method, options, html_options.merge(data_options))
        end
      end
    end
  end
end
