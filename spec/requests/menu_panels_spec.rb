require 'spec_helper'

describe "Menu Panel:" do

  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  
  # The menu bar should only appear on the home page when signed in
  describe "Home page" do
    describe "for signed-in users" do
      before do 
        sign_in user 
        visit root_path
      end
        
      it 'should have a nav#minibar bar' do
        expect(page).to have_selector('nav#minibar')
      end
    end
    
    describe "for non signed-in users" do
      before { visit root_path }
      it 'should not have a nav#minibar bar' do
        expect(page).not_to have_selector('nav#minibar')
      end
    end
  end
  
  # The menu bar shouldn't appear on the standard static pages: contact page, help page etc
  describe "Help page" do
    describe "for signed-in users" do
      before { sign_in user }
      before { visit help_path }
      it 'should not have a nav#minibar bar' do
        expect(page).not_to have_selector('nav#minibar')
      end
    end
    
    describe "for non signed-in users" do
      before { visit help_path }
      it 'should not have a nav#minibar bar' do
        expect(page).not_to have_selector('nav#minibar')
      end
    end
  end
  
  describe "About page" do
    describe "for signed-in users" do
      before { sign_in user }
      before { visit about_path }
      it 'should not have a nav#minibar bar' do
        expect(page).not_to have_selector("nav#minibar")
      end
    end
    
    describe "for non signed-in users" do
      before { visit about_path }
      it 'should not have a nav#minibar bar' do
        expect(page).not_to have_selector("nav#minibar")
      end
    end
  end
  
  describe "Contact page" do
    describe "for signed-in users" do
      before { sign_in user }
      before { visit contact_path }
      it 'should not have a nav#minibar bar' do
        expect(page).not_to have_selector('nav#minibar')
      end
    end
    
    describe "for non signed-in users" do
      before { visit contact_path }
      it 'should not have a nav#minibar bar' do
        expect(page).not_to have_selector('nav#minibar')
      end
    end
  end
  
  # The menu bar should not appear on sign-in or register error pages
  describe "Sign in error page" do
    before { visit signin_path }
    before { click_button "Sign in" }

    it 'should not have a nav#minibar bar' do
      expect(page).not_to have_selector('nav#minibar')
    end
  end
  
  describe "Register error page" do
    before { visit register_path }
    before { click_button "Create my account" }

    it 'should not have a nav#minibar bar' do
      expect(page).not_to have_selector('nav#minibar')
    end
  end
  
  # Making sure that menu options navigate to the right location
  describe "opening the sample set dropdown" do
    before { sign_in user }
    before { visit root_path }
    
    describe "and clicking the Create New link" do
      before do
        click_link('entities_new')
      end
  
      it "should open up the create entity page" do
        expect(page).to have_title('New Entity')
      end
    end
    
    describe "and clicking the View All link" do
      before do
        click_link('entities_index')
      end
  
      it "should open up the entity index page" do
        expect(page).to have_title('Entity List')
      end
    end
  end 
  
  # describe "opening the  dropdown" do
    # before { sign_in user }
    # before { visit root_path }
#     
    # describe "and clicking the Create New link" do
      # before do
        # click_link('samples_new')
      # end
#   
      # it "should open up the create sample page" do
        # expect(page).to have_title('New Sample')
      # end
    # end
#     
    # describe "and clicking the View All link" do
      # before do
        # click_link('samples_index')
      # end
#   
      # it "should open up the sample index page" do
        # expect(page).to have_title('Sample List')
      # end
    # end
  # end
  
end