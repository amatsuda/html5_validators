# frozen_string_literal: true

require 'test_helper'

class ActiveModelValidationTest < ActionDispatch::IntegrationTest
  teardown do
    Item._validators.clear
  end

  sub_test_case 'without validation' do
    test 'new form' do
      visit '/items/new'
      assert page.has_css? 'input#item_name'
      assert page.has_no_css? 'input#item_name[required=required]'
    end

    test 'new_without_html5_validation form' do
      visit '/items/new_without_html5_validation'
      assert page.has_css? 'textarea#item_description'
      assert page.has_no_css? 'textarea#item_description[required=required]'
    end
  end

  sub_test_case 'with required validation' do
    setup do
      Item.validates_presence_of :name, :description
    end
    test 'new form' do
      visit '/items/new'

      assert_equal 'required', find('input#item_name')[:required]
      assert_equal 'required', find('textarea#item_description')[:required]
    end
    test 'new_without_html5_validation form' do
      visit '/items/new_without_html5_validation'

      assert_nil find('input#item_name')[:required]
    end
    test 'new_with_required_true form' do
      visit '/items/new_with_required_true'

      assert_equal 'required', find('input#item_name')[:required]
    end
    test 'new_with_required_false form' do
      visit '/items/new_with_required_false'

      assert_nil find('input#item_name')[:required]
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

        assert_nil find('input#item_name')[:required]
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

        assert_nil find('input#item_name')[:required]
        assert_nil find('textarea#item_description')[:required]
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

      assert_equal '20', find('input#item_name')[:maxlength]
      assert_equal '100', find('textarea#item_description')[:maxlength]
    end
  end

  sub_test_case 'with minlength validation' do
    setup do
      Item.validates_length_of :name, minimum: 3
      Item.validates_length_of :description, minimum: 10
    end

    test 'new form' do
      visit '/items/new'

      assert_equal '3', find('input#item_name')[:minlength]
      assert_equal '10', find('textarea#item_description')[:minlength]
    end
  end
end
