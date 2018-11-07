# frozen_string_literal: true

require 'active_record'
require 'action_controller/railtie'

# config
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

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
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
class Person < ApplicationRecord
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
<%= f.text_area :bio %>
<% end %>

<%= form_with model: @person, id: 'form_with' do |f| %>
<%= f.text_field :name, id: 'person_name' %>
<%= f.text_area :bio, id: 'person_bio' %>
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

<%= form_with model: @person, id: 'form_with', auto_html5_validation: false do |f| %>
<%= f.text_field :name, id: 'person_name' %>
<%= f.text_field :email, id: 'person_email' %>
<% end %>
    ERB
  end

  def new_with_required_true
    @person = Person.new
    render inline: <<-ERB
<%= form_for @person, html: { id: 'form_for' } do |f| %>
<%= f.text_field :email, required: true %>
<% end %>

<%= form_with model: @person, id: 'form_with' do |f| %>
<%= f.text_field :email, required: true, id: 'person_email' %>
<% end %>
    ERB
  end

  def new_with_required_false
    @person = Person.new
    render inline: <<-ERB
<%= form_for @person, html: { id: 'form_for' } do |f| %>
<%= f.text_field :email, required: false %>
<% end %>

<%= form_with model: @person, id: 'form_with' do |f| %>
<%= f.text_field :email, required: false, id: 'person_email' %>
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

<%= form_with model: @item, id: 'form_with' do |f| %>
<%= f.text_field :name, id: 'item_name' %>
<%= f.text_area :description, id: 'item_description' %>
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

<%= form_with model: @item, id: 'form_with', auto_html5_validation: false do |f| %>
<%= f.text_field :name, id: 'item_name' %>
<%= f.text_area :description, id: 'item_description' %>
<% end %>
    ERB
  end

  def new_with_required_true
    @item = Item.new
    render inline: <<-ERB
<%= form_for @item, html: { id: 'form_for' } do |f| %>
<%= f.text_field :name, required: true %>
<% end %>

<%= form_with model: @item, id: 'form_with' do |f| %>
<%= f.text_field :name, required: true, id: 'item_name' %>
<% end %>
    ERB
  end

  def new_with_required_false
    @item = Item.new
    render inline: <<-ERB
<%= form_for @item, html: { id: 'form_for' } do |f| %>
<%= f.text_field :name, required: false %>
<% end %>

<%= form_with model: @item, id: 'form_with' do |f| %>
<%= f.text_field :name, required: false, id: 'item_name' %>
<% end %>
    ERB
  end
end

# helpers
module ApplicationHelper; end

#migrations
class CreateAllTables < ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[5.0] : ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :name
      t.string :email
      t.integer :age
      t.text :bio
    end
  end
end
