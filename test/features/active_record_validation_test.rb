# frozen_string_literal: true

require 'test_helper'

class ActiveRecordValidationTest < ActionDispatch::IntegrationTest
  teardown do
    Person._validators.clear
  end

  sub_test_case 'without validation' do
    test 'new form' do
      visit '/people/new'
      assert page.has_css? 'input#person_name'
      assert page.has_no_css? 'input#person_name[required=required]'
    end

    test 'new_without_html5_validation form' do
      visit '/people/new_without_html5_validation'
      assert page.has_css? 'input#person_email'
      assert page.has_no_css? 'input#person_email[required=required]'
    end
  end

  sub_test_case 'with required validation' do
    setup do
      Person.validates_presence_of :name, :bio
    end
    test 'new form' do
      visit '/people/new'

      assert_equal 'required', find('input#person_name')[:required]
      assert_equal 'required', find('textarea#person_bio')[:required]
    end
    test 'new_without_html5_validation form' do
      visit '/people/new_without_html5_validation'

      assert_nil find('input#person_name')[:required]
    end
    test 'new_with_required_true form' do
      visit '/people/new_with_required_true'

      assert_equal 'required', find('input#person_email')[:required]
    end
    test 'new_with_required_false form' do
      visit '/people/new_with_required_false'

      assert_nil find('input#person_email')[:required]
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

        assert_nil find('input#person_name')[:required]
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

        assert_nil find('input#person_name')[:required]
        assert_nil find('textarea#person_bio')[:required]
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

      assert_equal '20', find('input#person_name')[:maxlength]
      assert_equal '100', find('textarea#person_bio')[:maxlength]
    end
  end

  sub_test_case 'with minlength validation' do
    setup do
      Person.validates_length_of :name, minimum: 3
      Person.validates_length_of :bio, minimum: 10
    end

    test 'new form' do
      visit '/people/new'

      assert_equal '3', find('input#person_name')[:minlength]
      assert_equal '10', find('textarea#person_bio')[:minlength]
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

        assert_equal 'required', find('input#person_name')[:required]
        assert_equal '100', find('textarea#person_bio')[:maxlength]
      end
    end

    sub_test_case 'without an active context' do
      setup do
        Person.validates_presence_of :name, on: :update
      end
      test 'new form' do
        visit '/people/new'

        assert_nil find('input#person_name')[:required]
        assert_nil find('textarea#person_bio')[:maxlength]
      end
    end
  end
end
