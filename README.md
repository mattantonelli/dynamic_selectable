# DynamicSelectable

DynamicSelectable is a [Rails](http://github.com/rails/rails) gem that allows you to easily create `collection_select` fields with results that dynamically populate a related field. The dynamic population occurs with the help of the jQuery library [*jquery-dynamic-selectable*](http://railsguides.net/cascading-selects-with-ajax-in-rails/) written by [Andrey Koleshko](http://railsguides.net/about-author/).

How about a use case? Let's say your application allowed users to look up parts for their vehicle. A user selecting their car's model might include the following:

1. User selects the `Make` of their vehicle
2. The `Model` field is populated with models of the selected `Make`
3. User selects the `Model` of their vehicle

DynamicSelectable makes the above easy to do by providing a generator for your dynamic `collection_select` along with a new `FormHelper` method called `dynamic_collection_select`.

To see this gem in action, you can check out the sample application [here](https://github.com/mattantonelli/dynamic-selectable-test).

## Updating from 0.0.2

***Warning:*** *If you are updating from `0.0.2` you will need to re-generate any content created with* `rails generate dynamic_selectable:select`.

## Installation

Add the following line to your application's Gemfile:

```ruby
gem 'dynamic_selectable', git: 'https://github.com/atni/dynamic_selectable.git'
```

Install the gem by running `bundle install`.

Run the gem's install generator:

```
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

To generate the controller and route necessary for your selection of `Make` to dynamically populate your selection of `Model`, run the following:

```
# Usage: rails generate dynamic_selectable:select parent child value_method text_method [sort_col:asc/desc]
$ rails generate dynamic_selectable:select make model id name name:asc
```

Now you just need to build your form. The method `dynamic_collection_select` is very similar to [collection_select](http://apidock.com/rails/ActionView/Helpers/FormOptionsHelper/collection_select), but contains the new `dynamic_model` parameter. This parameter is a symbol representing the child model whose collection will be populated based on the value selected in this parent field.

If you would like to submit the value of the `dynamic_collection_select` with the form, just add `{ submit_with_form: true }` to the `options` hash.


```ruby
def dynamic_collection_select(object, method, dynamic_model, collection, value_method, text_method,
                              options = {}, html_options = {})
```

A very simple form would look something like this:

```html+erb
<%= form_for(@vehicle) do |f| %>
  <div>
    <%= label_tag :make_id %>
    <%= dynamic_collection_select :vehicle, :make_id, :model, Make.all, :id, :name,
        { include_blank: true }, {} %>
  </div>

  <div>
    <%= f.label :model_id %>
    <%= f.collection_select :model_id, [], :id, :name, {}, {} %>
  </div>

  <%# ... %>
<% end %>
```

That's it. Happy selecting!

## Overriding data attributes

By default, DynamicSelectable uses the `object` and `method` parameters of `dynamic_collection_select` to generate data attributes used by the gem's Javascript. Depending on your model, or if you are creating a form with a gem like [Ransack](https://github.com/activerecord-hackery/ransack), the values you provide for these parameters could prevent DynamicSelectable from generating the necessary data attributes properly. To resolve this, you can manually specify these attributes in a `data` hash within your tag's `html_options` hash. For example:

```html+erb
<%= dynamic_collection_select :q, :make_id_eq, :model, Make.all, :id, :name,
  {}, { data: { dynamic_selectable_url:    '/dynamic_selectable/makes/:make_id/models',
                dynamic_selectable_target: '#q_model_id_eq' } } %>
```

The value for `dynamic_selectable_url` can be found in your routes:

```
$ rake routes | grep dynamic
dynamic_selectable_make_models GET    /dynamic_selectable/makes/:make_id/models(.:format) dynamic_selectable/make_models#index
```

and the value for `dynamic_selectable_target` is generated with your form. This can be found by inspecting the child element in your web browser.

## Removing generated content

#### Remove a generated controller/route

```
$ rm app/controllers/dynamic_selectable/models_controller.rb
```

and remove the related line from your `routes.rb`:

```ruby
get ':make_id/models', to: 'models#index', as: :models
```

#### Complete uninstallation

```bash
$ rm -rf app/controllers/dynamic_selectable
```

and remove the following block from your `routes.rb`:

```ruby
namespace :dynamic_selectable do
  # ...
end
```

## Contributing

1. Fork it ( https://github.com/atni/dynamic_selectable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

