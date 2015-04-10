# DynamicSelectable

DynamicSelectable is a [Rails](http://github.com/rails/rails) gem that allows you to easily create `collection_select` fields with results that dynamically populate a related field. The dynamic population occurs with the help of the jQuery library [*jquery-dynamic-selectable*](http://railsguides.net/cascading-selects-with-ajax-in-rails/) written by [Andrey Koleshko](http://railsguides.net/about-author/).

How about a use case? Let's say your application allowed users to look up parts for their vehicle. A user selecting their car's model might include the following:

1. User selects the `Make` of their vehicle
2. The `Model` field is populated with models of the selected `Make`
3. User selects the `Model` of their vehicle

DynamicSelectable makes the above easy to do by providing a generator for your dynamic `collection_select` along with a new `FormHelper` method called `dynamic_collection_select`.

## Installation

Add the following line to your application's Gemfile:

```ruby
gem 'dynamic_selectable', git: 'https://github.com/atni/dynamic_selectable.git'
```

Install the gem by running `bundle install`.

Run the gem's install generator:

```bash
$ rails generate dynamic_selectable:install
```

If you are using [Devise](https://github.com/plataformatec/devise) for user authentication, you will want to add a before_filter to skip authentication in the newly generated `app/controllers/select/select_controller.rb`:

```ruby
class DynamicSelectable::SelectController < ApplicationController
  # skip_before_filter :authenticate_user!
end
```

Finally, you'll want to add the following require to your `application.js`:

```javascript
//= require jquery-dynamic-selectable
```

Now that you have DynamicSelectable installed, you're ready to start creating some `dynamic_collection_select` fields in your application!

## Usage

The first step to creating a `dynamic_collection_select` is to generate a controller and route for it. Using the vehicle example from above, your `Make` and `Model` models might look like the following:

```ruby
# == Schema Information
#
# Table name: makes
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Make < ActiveRecord::Base
end
```

```ruby
# == Schema Information
#
# Table name: models
#
#  id         :integer          not null, primary key
#  name       :string
#  make_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Model < ActiveRecord::Base
  belongs_to :make
end
```

To generate the controller and route necessary for your selection of `Make` to dynamically populate your selection of `Model`, you would run the following:

```bash
# Usage: rails generate dynamic_selectable:select parent child value_method text_method [sort_col:asc/desc]
$ rails generate dynamic_selectable:select make model id name name:asc
```

Now you just need to build your form. The method `dynamic_collection_select` is very similar to `collection_select`, but contains some new parameters:

<dl>
  <dt>current</dt>
  <dd>Symbol representing the class of the object being built in the current form</dd>

  <dt>select_parent</dt>
  <dd>The parent field that will determine the population of the related child field</dd>

  <dt>select_child</dt>
  <dd>The child field that will be populated based on the selection in the parent field</dd>
</dl>

```ruby
def dynamic_collection_select(current, select_parent, select_child, collection,
                              value_method, text_method, options, html_options)
```

A very simple form would look something like this:

```html+erb
<%= form_for(@vehicle) do |f| %>
  <div class="form-group">
    <%= label_tag :make_id %>
    <%= dynamic_collection_select :vehicle, :make, :model, Make.all, :id, :name,
        { include_blank: true }, { class: 'form-control' } %>
  </div>

  <div class="form-group">
    <%= f.label :model_id %>
    <%= f.collection_select :model_id, [], :id, :name, {}, { class: 'form-control' } %>
  </div>

  <%# ... %>
<% end %>
```

That's it. Happy selecting!

## Contributing

1. Fork it ( https://github.com/atni/dynamic_selectable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request