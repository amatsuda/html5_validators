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

    context 'disabling html5_validation in class level' do
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

    context 'disabling html5_validations in gem' do
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
end
