# frozen_string_literal: true

require 'test_helper'

class ActiveModelValidationTest < ActionDispatch::IntegrationTest
  FORM_ID_LIST = if Rails::VERSION::STRING >= '5.1'
                   %w[#form_for #form_with].freeze
                 else
                   %w[#form_for].freeze
                 end

  teardown do
    Item._validators.clear
  end

  sub_test_case 'without validation' do
    test 'new form' do
      visit '/items/new'
      FORM_ID_LIST.each do |form|
        assert page.has_css? "#{form} input#item_name"
        assert page.has_no_css? "#{form} input#item_name[required=required]"
      end
    end

    test 'new_without_html5_validation form' do
      visit '/items/new_without_html5_validation'
      FORM_ID_LIST.each do |form|
        assert page.has_css? "#{form} textarea#item_description"
        assert page.has_no_css? "#{form} textarea#item_description[required=required]"
      end
    end
  end

  sub_test_case 'with required validation' do
    setup do
      Item.validates_presence_of :name, :description
    end
    test 'new form' do
      visit '/items/new'
      FORM_ID_LIST.each do |form|
        assert_equal 'required', find("#{form} input#item_name")[:required]
        assert_equal 'required', find("#{form} textarea#item_description")[:required]
      end
    end
    test 'new_without_html5_validation form' do
      visit '/items/new_without_html5_validation'
      FORM_ID_LIST.each do |form|
        assert_nil find("#{form} input#item_name")[:required]
      end
    end
    test 'new_with_required_true form' do
      visit '/items/new_with_required_true'
      FORM_ID_LIST.each do |form|
        assert_equal 'required', find("#{form} input#item_name")[:required]
      end
    end
    test 'new_with_required_false form' do
      visit '/items/new_with_required_false'
      FORM_ID_LIST.each do |form|
        assert_nil find("#{form} input#item_name")[:required]
      end
    end
    sub_test_case 'disabling html5_validation in class level' do
      setup do
        Item.class_eval do |kls|
          kls.auto_html5_validation = false
        end
      end
      teardown do
        Item.class_eval do |kls|
          kls.auto_html5_validation = nil
        end
      end
      test 'new form' do
        visit '/items/new'
        FORM_ID_LIST.each do |form|
          assert_nil find("#{form} input#item_name")[:required]
        end
      end
    end

    sub_test_case 'disabling html5_validations in gem' do
      setup do
        Html5Validators.enabled = false
      end
      teardown do
        Html5Validators.enabled = true
      end
      test 'new form' do
        visit '/items/new'
        FORM_ID_LIST.each do |form|
          assert_nil find("#{form} input#item_name")[:required]
          assert_nil find("#{form} textarea#item_description")[:required]
        end
      end
    end
  end

  sub_test_case 'with maxlength validation' do
    setup do
      Item.validates_length_of :name, maximum: 20
      Item.validates_length_of :description, maximum: 100
    end

    test 'new form' do
      visit '/items/new'
      FORM_ID_LIST.each do |form|
        assert_equal '20', find("#{form} input#item_name")[:maxlength]
        assert_equal '100', find("#{form} textarea#item_description")[:maxlength]
      end
    end
  end

  sub_test_case 'with minlength validation' do
    setup do
      Item.validates_length_of :name, minimum: 3
      Item.validates_length_of :description, minimum: 10
    end

    test 'new form' do
      visit '/items/new'
      FORM_ID_LIST.each do |form|
        assert_equal '3', find("#{form} input#item_name")[:minlength]
        assert_equal '10', find("#{form} textarea#item_description")[:minlength]
      end
    end
  end
end
