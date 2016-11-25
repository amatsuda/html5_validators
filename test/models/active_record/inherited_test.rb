# frozen_string_literal: true
require 'test_helper'

if defined? ActiveRecord
  class Html5Validators::ActiveRecordExtensionTest < ActiveSupport::TestCase
    test 'An AR model' do
      assert_respond_to Class.new(ActiveRecord::Base), :auto_html5_validation
    end

    test "Changing a model's auto_html5_validation value doesn't affect other model's auto_html5_validation value" do
      cow = Class.new ApplicationRecord
      horse = Class.new ApplicationRecord
      cow.auto_html5_validation = false

      assert_equal true, horse.auto_html5_validation
    end
  end
end
