require 'spec_helper'

feature 'person#new' do
  context 'without validation' do
    scenario 'new form' do
      visit '/people/new'
      page.should have_css('input#person_name')
      page.should_not have_css('input#person_name[required=required]')
    end

    scenario 'new_without_html5_validation form' do
      visit '/people/new_without_html5_validation'
      page.should have_css('input#person_email')
      page.should_not have_css('input#person_email[required=required]')
    end
  end

  context 'with required validation' do
    background do
      Person.validates_presence_of :name, :bio
    end
    after do
      Person._validators.clear
    end
    scenario 'new form' do
      visit '/people/new'

      find('input#person_name')[:required].should == 'required'
      find('textarea#person_bio')[:required].should == 'required'
    end
    scenario 'new_without_html5_validation form' do
      visit '/people/new_without_html5_validation'

      find('input#person_name')[:required].should be_nil
    end
    scenario 'new_without_required_html5_validation form' do
      visit '/people/new_without_required_html5_validation'

      find('input#person_name')[:required].should be_nil
    end
    scenario 'new_with_required_true form' do
      visit '/people/new_with_required_true'

      find('input#person_email')[:required].should == 'required'
    end

    context 'disabling html5_validation in class level' do
      context 'disabling all' do
        background do
          Person.class_eval do |kls|
            kls.auto_html5_validation = false
          end
        end
        after do
          Person.class_eval do |kls|
            kls.auto_html5_validation = nil
          end
        end
        scenario 'new form' do
          visit '/people/new'

          find('input#person_name')[:required].should be_nil
        end
      end

      context 'disabling requied only' do
        background do
          Person.class_eval do |kls|
            kls.auto_html5_validation = {:required => false}
          end
        end
        after do
          Person.class_eval do |kls|
            kls.auto_html5_validation = nil
          end
        end
        scenario 'new form' do
          visit '/people/new'

          find('input#person_name')[:required].should be_nil
        end
      end
    end

    context 'disabling html5_validations in gem' do
      context 'disabling all' do
        background do
          Html5Validators.enabled = false
        end
        after do
          Html5Validators.enabled = true
        end
        scenario 'new form' do
          visit '/people/new'

          find('input#person_name')[:required].should be_nil
          find('textarea#person_bio')[:required].should be_nil
        end
      end

      context 'disabling required only' do
        background do
          Html5Validators.configure do |config|
            config.validation[:required] = false
          end
        end

        after do
          Html5Validators.configure do |config|
            config.validation[:required] = true
          end
        end

        scenario 'new form' do
          visit '/items/new'

          find('input#item_name')[:required].should be_nil
          find('textarea#item_description')[:required].should be_nil
        end
      end
    end
  end

  context 'with maxlength validation' do
    background do
      Person.validates_length_of :name, {:maximum => 20}
      Person.validates_length_of :bio, {:maximum => 100}
    end

    scenario 'new form' do
      visit '/people/new'

      find('input#person_name')[:maxlength].should == '20'
      find('textarea#person_bio')[:maxlength].should == '100'
    end
  end

  context 'with minlength validation' do
    background do
      Person.validates_length_of :name, {:minimum => 3}
      Person.validates_length_of :bio, {:minimum => 10}
    end

    scenario 'new form' do
      visit '/people/new'

      find('input#person_name')[:minlength].should == '3'
      find('textarea#person_bio')[:minlength].should == '10'
    end
  end
end

feature 'item#new' do
  context 'without validation' do
    scenario 'new form' do
      visit '/items/new'
      page.should have_css('input#item_name')
      page.should_not have_css('input#item_name[required=required]')
    end

    scenario 'new_without_html5_validation form' do
      visit '/items/new_without_html5_validation'
      page.should have_css('textarea#item_description')
      page.should_not have_css('textarea#item_description[required=required]')
    end
  end

  context 'with required validation' do
    background do
      Item.validates_presence_of :name, :description
    end
    after do
      Item._validators.clear
    end
    scenario 'new form' do
      visit '/items/new'

      find('input#item_name')[:required].should == 'required'
      find('textarea#item_description')[:required].should == 'required'
    end
    scenario 'new_without_html5_validation form' do
      visit '/items/new_without_html5_validation'

      find('input#item_name')[:required].should be_nil
    end
    scenario 'new_without_required_html5_validation form' do
      visit '/items/new_without_required_html5_validation'

      find('input#item_name')[:required].should be_nil
    end
    scenario 'new_with_required_true form' do
      visit '/items/new_with_required_true'

      find('input#item_name')[:required].should == 'required'
    end

    context 'disabling html5_validation in class level' do
      context 'disabling all' do
        background do
          Item.class_eval do |kls|
            kls.auto_html5_validation = false
          end
        end
        after do
          Item.class_eval do |kls|
            kls.auto_html5_validation = nil
          end
        end
        scenario 'new form' do
          visit '/items/new'

          find('input#item_name')[:required].should be_nil
        end
      end

      context 'disabling required only' do
        background do
          Item.class_eval do |kls|
            kls.auto_html5_validation = {:required => false}
          end
        end
        after do
          Item.class_eval do |kls|
            kls.auto_html5_validation = nil
          end
        end
        scenario 'new form' do
          visit '/items/new'

          find('input#item_name')[:required].should be_nil
        end
      end
    end

    context 'disabling html5_validations in gem' do
      context 'disabling all' do
        background do
          Html5Validators.enabled = false
        end
        after do
          Html5Validators.enabled = true
        end
        scenario 'new form' do
          visit '/items/new'

          find('input#item_name')[:required].should be_nil
          find('textarea#item_description')[:required].should be_nil
        end
      end

      context 'disabling required only' do
        background do
          Html5Validators.configure do |config|
            config.validation[:required] = false
          end
        end

        after do
          Html5Validators.configure do |config|
            config.validation[:required] = true
          end
        end

        scenario 'new form' do
          visit '/items/new'

          find('input#item_name')[:required].should be_nil
          find('textarea#item_description')[:required].should be_nil
        end
      end
    end
  end

  context 'with maxlength validation' do
    background do
      Item.validates_length_of :name, {:maximum => 20 }
      Item.validates_length_of :description, {:maximum => 100}
    end

    scenario 'new form' do
      visit '/items/new'

      find('input#item_name')[:maxlength].should == '20'
      find('textarea#item_description')[:maxlength].should == '100'
    end
  end

  context 'with minlength validation' do
    background do
      Item.validates_length_of :name, {:minimum => 3}
      Item.validates_length_of :description, {:minimum => 10}
    end

    scenario 'new form' do
      visit '/items/new'

      find('input#item_name')[:minlength].should == '3'
      find('textarea#item_description')[:minlength].should == '10'
    end
  end
end
