require 'spec_helper'

if defined? ActiveRecord
  describe Html5Validators::ActiveRecordExtension do
    subject { Class.new(ActiveRecord::Base) }
    it { should respond_to :auto_html5_validation }
  end
end
