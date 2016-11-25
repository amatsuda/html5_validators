# frozen_string_literal: true
require 'test_helper'

if defined? ActiveRecord
  class Html5Validators::ActiveRecordExtensionTest < ActiveSupport::TestCase
    test 'An AR model' do
      assert_respond_to Class.new(ActiveRecord::Base), :auto_html5_validation
    end
  end
end
