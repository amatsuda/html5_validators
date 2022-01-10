# HTML5Validators

Automatic client-side validation using HTML5 Form Validation

## What is this?

html5_validators is a gem/plugin for Rails 3+ that enables automatic client-side
validation using ActiveModel + HTML5. Once you bundle this gem on your app,
the gem will automatically translate your model validation code into HTML5
validation attributes on every `form_for` invocation unless you explicitly
cancel it.

## Features

### PresenceValidator => required

* Model
```ruby
class User
  include ActiveModel::Validations
  validates_presence_of :name
end
```

* View
```erb
<%= f.text_field :name %>
```
other `text_field`ish helpers, `text_area`, `radio_button`, and `check_box` are also available

* HTML
```html
<input id="user_name" name="user[name]" required="required" type="text" />
```

* SPEC

http://dev.w3.org/html5/spec/Overview.html#attr-input-required

![PresenceValidator](https://raw.githubusercontent.com/amatsuda/html5_validators/0928dc13fdd1a7746deed9a9cf7e865e13039df8/assets/presence.png)

### LengthValidator => maxlength

* Model
```ruby
class User
  include ActiveModel::Validations
  validates_length_of :name, maximum: 10
end
```

* View
```erb
<%= f.text_field :name %>
```
`text_area` is also available

* HTML
```html
<input id="user_name" maxlength="10" name="user[name]" size="10" type="text" />
```

* SPEC

http://dev.w3.org/html5/spec/Overview.html#attr-input-maxlength

### NumericalityValidator => max, min

* Model
```ruby
class User
  include ActiveModel::Validations
  validates_numericality_of :age, greater_than_or_equal_to: 20
end
```

* View (be sure to use number_field)
```erb
<%= f.number_field :age %>
```

* HTML
```html
<input id="user_age" min="20" name="user[age]" size="30" type="number" />
```

* SPEC

http://dev.w3.org/html5/spec/Overview.html#attr-input-max
http://dev.w3.org/html5/spec/Overview.html#attr-input-min

![NumericalityValidator](https://raw.githubusercontent.com/amatsuda/html5_validators/0928dc13fdd1a7746deed9a9cf7e865e13039df8/assets/numericality.png)

### And more (coming soon...?)
:construction:

## Disabling automatic client-side validation

There are four ways to cancel the automatic HTML5 validation.

### 1. Per form (via form_for option)

Set `auto_html5_validation: false` to `form_for` parameter.

* View
```erb
<%= form_for @user, auto_html5_validation: false do |f| %>
  ...
<% end %>
```

### 2. Per model instance (via model attribute)

Set `auto_html5_validation = false` attribute to ActiveModelish object.

* Controller
```ruby
@user = User.new auto_html5_validation: false
```

* View
```erb
<%= form_for @user do |f| %>
  ...
<% end %>
```

### 3. Per model class (via model class attribute)

Set `auto_html5_validation = false` to ActiveModelish class' class variable.
This configuration will never be propagated to inherited children classes.

* Model
```ruby
class User < ActiveRecord::Base
  self.auto_html5_validation = false
end
```

* Controller
```ruby
@user = User.new
```

* View
```erb
<%= form_for @user do |f| %>
  ...
<% end %>
```

### 4. Globally (via HTML5Validators module configuration)

Set `config.enabled = false` to Html5Validators module.
Maybe you want to put this in your test_helper, or add a controller filter as
follows for development mode.

* Controller
```ruby
# an example filter that disables the validator if the request has {h5v: 'disable'} params
around_action do |controller, block|
  h5v_enabled_was = Html5Validators.enabled
  Html5Validators.enabled = false if params[:h5v] == 'disable'
  block.call
  Html5Validators.enabled = h5v_enabled_was
end
```

## Supported versions

* Ruby 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 3.0, 3.1, 3.2 (trunk)

* Rails 3.2.x, 4.0.x, 4.1, 4.2, 5.0, 5.1, 5.2, 6.0, 6.1, 7.0, 7.1 (edge)

* HTML5 compatible browsers


## Installation

Put this line into your Gemfile:
```ruby
gem 'html5_validators'
```

Then bundle:
```
% bundle
```

## Notes

When accessed by an HTML5 incompatible lagacy browser, these extra attributes
will just be ignored.

## Todo

* more validations


## Copyright

Copyright (c) 2011 Akira Matsuda. See MIT-LICENSE for further details.
