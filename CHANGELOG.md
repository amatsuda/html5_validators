## 1.8.0

* Added support for AR `validation_context` such as `on: :create` or `on: :update`

## 1.7.0

* Fixed a bug that `required: false` helper option does not override `required: true` value from PresenceValidator [@sandipransing]


## 1.5.0

* Rails 5 support

* Changed `auto_html5_validation` config behavior not to propagate to children classes


## 1.4.0

* Dropped Ruby 1.8 support

* Dropped Ruby 1.9 support

* Dropped Rails 3.2 support

* Fixed a bug that `maxlength` validation for inputs which can be blank was ignored [@kv109]

* Fixed a bug that `auto_html5_validation` was not properly enabled for models that are loaded after loading this gem


## 1.3.0

* Switched from `alias_method_chain` to `Module#prepend` on Ruby 2 and Rails 4

* Added `minlength` support


## 1.2.2

* Fixed undefined method `auto_html5_validation` error for non-AR Active Model models


## 1.2.1

* Fixed a bug that `minlength / maxlength` values were assigned to `min / max`


## 1.2.0

* Added global `Html5Validators.enabled` flag [@sinsoku]

* Fixed a bug that some Symbol keyed helper options were ignored [@lucas-nelson]


## 1.1.3

* Fixed a bug that AR::Base.inherited conflicts with other gems [@tricknotes]


## 1.1.2

* Fixed a bug that `cattr_accessor` + `:instance_accessor => false` still creates an `instance_accessor` on AR 3.0 and 3.1


## 1.1.1

* Rails 4 support


## 1.1.0

* Added `maxlength` validator support for `text_area` [@ursm]
