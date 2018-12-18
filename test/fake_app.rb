# frozen_string_literal: true

require 'action_controller/railtie'
require 'active_model'
begin
  require 'active_record'
rescue LoadError
end

# config
class Html5ValidatorsTestApp < Rails::Application
  config.secret_token = "You know I'm born to lose, and gambling's for fools, But that's the way I like it baby, I don't wanna live for ever, And don't forget the joker!"
  config.session_store :cookie_store, key: '_myapp_session'
  config.active_support.deprecation = :log
  config.eager_load = false
end
Rails.application.initialize!

# routes
Rails.application.routes.draw do
  resources :people, only: [:new, :create] do
    collection do
      get :new_without_html5_validation
      get :new_with_required_true
      get :new_with_required_false
    end
  end
  resources :items, only: [:new, :create] do
    collection do
      get :new_without_html5_validation
      get :new_with_required_true
      get :new_with_required_false
    end
  end
end

# models
if defined? ActiveRecord
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

  # migrations
  ActiveRecord::Base.connection.instance_eval do
    create_table :people do |t|
      t.string :name
      t.string :password
      t.string :email
      t.integer :age
      t.text :bio
      t.string :user_type
      t.boolean :terms_of_service
    end
  end

  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
  class Person < ApplicationRecord
  end
end

class Item
  if ActiveModel::VERSION::STRING >= '4'
    include ActiveModel::Model
  else
    include ActiveModel::Validations
    include ActiveModel::Conversion
    def persisted?; false; end
  end

  attr_accessor :name, :description
end

# controllers
class ApplicationController < ActionController::Base; end
class PeopleController < ApplicationController
  def new
    @person = Person.new
    render inline: <<-ERB
<%= form_for @person, html: { id: 'form_for' } do |f| %>
<%= f.text_field :name %>
<%= f.password_field :password %>
<%= f.text_area :bio %>
<%= f.select :user_type, %w(normal admin), include_blank: true %>
<%= f.check_box :terms_of_service %>
<% end %>

<% if Rails::VERSION::STRING >= '5.1' %>
<%= form_with model: @person, id: 'form_with' do |f| %>
<%= f.text_field :name, id: 'person_name' %>
<%= f.password_field :password, id: 'person_password' %>
<%= f.text_area :bio, id: 'person_bio' %>
<%= f.select :user_type, %w(normal admin), include_blank: true %>
<%= f.check_box :terms_of_service %>
<% end %>
<% end %>
    ERB
  end

  def new_without_html5_validation
    @person = Person.new
    render inline: <<-ERB
<%= form_for @person, html: { id: 'form_for' }, auto_html5_validation: false do |f| %>
<%= f.text_field :name %>
<%= f.text_field :email %>
<% end %>

<% if Rails::VERSION::STRING >= '5.1' %>
<%= form_with model: @person, id: 'form_with', auto_html5_validation: false do |f| %>
<%= f.text_field :name, id: 'person_name' %>
<%= f.text_field :email, id: 'person_email' %>
<% end %>
<% end %>
    ERB
  end

  def new_with_required_true
    @person = Person.new
    render inline: <<-ERB
<%= form_for @person, html: { id: 'form_for' } do |f| %>
<%= f.text_field :email, required: true %>
<% end %>

<% if Rails::VERSION::STRING >= '5.1' %>
<%= form_with model: @person, id: 'form_with' do |f| %>
<%= f.text_field :email, required: true, id: 'person_email' %>
<% end %>
<% end %>
    ERB
  end

  def new_with_required_false
    @person = Person.new
    render inline: <<-ERB
<%= form_for @person, html: { id: 'form_for' } do |f| %>
<%= f.text_field :email, required: false %>
<% end %>

<% if Rails::VERSION::STRING >= '5.1' %>
<%= form_with model: @person, id: 'form_with' do |f| %>
<%= f.text_field :email, required: false, id: 'person_email' %>
<% end %>
<% end %>
    ERB
  end
end
class ItemsController < ApplicationController
  def new
    @item = Item.new
    render inline: <<-ERB
<%= form_for @item, html: { id: 'form_for' } do |f| %>
<%= f.text_field :name %>
<%= f.text_area :description %>
<% end %>

<% if Rails::VERSION::STRING >= '5.1' %>
<%= form_with model: @item, id: 'form_with' do |f| %>
<%= f.text_field :name, id: 'item_name' %>
<%= f.text_area :description, id: 'item_description' %>
<% end %>
<% end %>
    ERB
  end

  def new_without_html5_validation
    @item = Item.new
    render inline: <<-ERB
<%= form_for @item, html: { id: 'form_for' }, auto_html5_validation: false do |f| %>
<%= f.text_field :name %>
<%= f.text_area :description %>
<% end %>

<% if Rails::VERSION::STRING >= '5.1' %>
<%= form_with model: @item, id: 'form_with', auto_html5_validation: false do |f| %>
<%= f.text_field :name, id: 'item_name' %>
<%= f.text_area :description, id: 'item_description' %>
<% end %>
<% end %>
    ERB
  end

  def new_with_required_true
    @item = Item.new
    render inline: <<-ERB
<%= form_for @item, html: { id: 'form_for' } do |f| %>
<%= f.text_field :name, required: true %>
<% end %>

<% if Rails::VERSION::STRING >= '5.1' %>
<%= form_with model: @item, id: 'form_with' do |f| %>
<%= f.text_field :name, required: true, id: 'item_name' %>
<% end %>
<% end %>
    ERB
  end

  def new_with_required_false
    @item = Item.new
    render inline: <<-ERB
<%= form_for @item, html: { id: 'form_for' } do |f| %>
<%= f.text_field :name, required: false %>
<% end %>

<% if Rails::VERSION::STRING >= '5.1' %>
<%= form_with model: @item, id: 'form_with' do |f| %>
<%= f.text_field :name, required: false, id: 'item_name' %>
<% end %>
<% end %>
    ERB
  end
end

# helpers
module ApplicationHelper; end
