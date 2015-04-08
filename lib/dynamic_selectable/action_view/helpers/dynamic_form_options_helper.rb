include ActionView::Helpers::FormOptionsHelper

module DynamicSelectable
  module ActionView
    module Helpers
      module DynamicFormOptionsHelper
        def dynamic_collection_select(current, select_parent, select_child, collection, value_method, text_method,
                                      options, html_options)
          select_url    = "select_#{select_child.to_s.pluralize}_path"
          parent_id     = ":#{select_parent}_id"
          select_target = "##{current}_#{select_child}_id"

          data_options = { data: { dynamic_selectable_url: send(select_url, parent_id),
                                   dynamic_selectable_target: select_target } }

          collection_select(nil, nil, collection, value_method, text_method, options, html_options.merge(data_options))
        end
      end
    end
  end
end
