# frozen_string_literal: true

require 'test_helper'

class ActiveRecordValidationTest < ActionDispatch::IntegrationTest
  FORM_ID_LIST = if Rails::VERSION::STRING >= '5.1'
                   %w[#form_for #form_with].freeze
                 else
                   %w[#form_for].freeze
                 end

  teardown do
    Person._validators.clear
  end

  sub_test_case 'without validation' do
    test 'new form' do
      visit '/people/new'
      FORM_ID_LIST.each do |form|
        assert page.has_css? "#{form} input#person_name"
        assert page.has_no_css? "#{form} input#person_name[required=required]"
      end
    end

    test 'new_without_html5_validation form' do
      visit '/people/new_without_html5_validation'
      FORM_ID_LIST.each do |form|
        assert page.has_css? "#{form} input#person_email"
        assert page.has_no_css? "#{form} input#person_email[required=required]"
      end
    end
  end

  sub_test_case 'with required validation' do
    setup do
      Person.validates_presence_of :name, :password, :bio, :blood_type, :terms_of_service, :user_type
    end
    test 'new form' do
      visit '/people/new'
      FORM_ID_LIST.each do |form|
        assert_equal 'required', find("#{form} input#person_name")[:required]
        assert_equal 'required', find("#{form} input#person_password")[:required]
        assert_equal 'required', find("#{form} textarea#person_bio")[:required]
        assert_equal 'required', find("#{form} select[name='person[blood_type]']")[:required]
        assert_equal 'required', find("#{form} input[name='person[terms_of_service]']")[:required]
        assert_equal 2, all("#{form} input[name='person[user_type]'][required=required]").size
      end
    end
    test 'new_without_html5_validation form' do
      visit '/people/new_without_html5_validation'
      FORM_ID_LIST.each do |form|
        assert_nil find("#{form} input#person_name")[:required]
      end
    end
    test 'new_with_required_true form' do
      visit '/people/new_with_required_true'
      FORM_ID_LIST.each do |form|
        assert_equal 'required', find("#{form} input#person_email")[:required]
      end
    end
    test 'new_with_required_false form' do
      visit '/people/new_with_required_false'
      FORM_ID_LIST.each do |form|
        assert_nil find("#{form} input#person_email")[:required]
      end
    end
    sub_test_case 'disabling html5_validation in class level' do
      setup do
        Person.class_eval do |kls|
          kls.auto_html5_validation = false
        end
      end
      teardown do
        Person.class_eval do |kls|
          kls.auto_html5_validation = nil
        end
      end
      test 'new form' do
        visit '/people/new'
        FORM_ID_LIST.each do |form|
          assert_nil find("#{form} input#person_name")[:required]
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
        visit '/people/new'
        FORM_ID_LIST.each do |form|
          assert_nil find("#{form} input#person_name")[:required]
          assert_nil find("#{form} input#person_password")[:required]
          assert_nil find("#{form} textarea#person_bio")[:required]
          assert_nil find("#{form} select[name='person[blood_type]']")[:required]
          assert_nil find("#{form} input[name='person[terms_of_service]']")[:required]
          all("#{form} input[name='person[user_type]']").each do |radio|
            assert_nil radio[:required]
          end
        end
      end
    end
  end

  sub_test_case 'with maxlength validation' do
    setup do
      Person.validates_length_of :name, maximum: 20
      Person.validates_length_of :bio, maximum: 100
    end

    test 'new form' do
      visit '/people/new'
      FORM_ID_LIST.each do |form|
        assert_equal '20', find("#{form} input#person_name")[:maxlength]
        assert_equal '100', find("#{form} textarea#person_bio")[:maxlength]
      end
    end
  end

  sub_test_case 'with minlength validation' do
    setup do
      Person.validates_length_of :name, minimum: 3
      Person.validates_length_of :bio, minimum: 10
    end

    test 'new form' do
      visit '/people/new'
      FORM_ID_LIST.each do |form|
        assert_equal '3', find("#{form} input#person_name")[:minlength]
        assert_equal '10', find("#{form} textarea#person_bio")[:minlength]
      end
    end
  end

  sub_test_case 'validation with context' do
    sub_test_case 'with an active context' do
      setup do
        Person.validates_presence_of :name, on: :create
        Person.validates_length_of :bio, maximum: 100, on: :create
      end
      test 'new form' do
        visit '/people/new'
        FORM_ID_LIST.each do |form|
          assert_equal 'required', find("#{form} input#person_name")[:required]
          assert_equal '100', find("#{form} textarea#person_bio")[:maxlength]
        end
      end
    end

    sub_test_case 'without an active context' do
      setup do
        Person.validates_presence_of :name, on: :update
      end
      test 'new form' do
        visit '/people/new'
        FORM_ID_LIST.each do |form|
          assert_nil find("#{form} input#person_name")[:required]
          assert_nil find("#{form} textarea#person_bio")[:maxlength]
        end
      end
    end
  end
end
