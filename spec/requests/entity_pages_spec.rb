require 'spec_helper'

describe "Entity pages" do

  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  
  describe "Index page" do
    
    describe "for signed-in users" do
      
      before { sign_in user }
      before { visit entities_path }
      
      it { should have_content('Entity List') }
      it { should have_title(full_title('Entity List')) }
      it { should_not have_title('| Home') }
      
      describe "with no entities in the system" do
        
        it "should have an information message" do
          expect(page).to have_content('No Entities found')
        end
      end
      
      describe "with entities in the system" do
        before do
          FactoryGirl.create(:entity, name: 'Project')
          FactoryGirl.create(:entity, name: 'Experiment')
          visit entities_path
        end
                
        it "should have correct table heading" do
          expect(page).to have_selector('table tr th', text: 'Entity ID')
          expect(page).to have_selector('table tr th', text: 'Entity Name')
        end
                   
        it "should list each entity" do
          Entity.paginate(page: 1).each do |entity|
            expect(page).to have_selector('table tr td', text: entity.id)
            expect(page).to have_selector('table tr td', text: entity.name)
          end
        end
        
      end

    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit entities_path }
        it { should have_title('Sign in') }
      end
    end
    
  end
  
  
  
  describe "Show page" do
    
    let!(:entity) { FactoryGirl.create(:entity, name: 'StorageLocation', 
                                                    exposeAs: 'Storage Location',
                                                    creator: user                                           
                                                    ) }
        
    describe "for signed-in users" do
      
      before { sign_in user }
      before { visit entity_path(entity) }
      
      let!(:page_heading) {"Entity " + entity.name}
      
      it { should have_selector('h1', :text => page_heading) }
      it { should have_title(full_title('Entity View')) }
      it { should_not have_title('| Home') }  
      it { should have_button('Edit Entity') }
      it { should have_button('Delete Entity') }
      
      describe "when clicking the edit button" do
        before { click_button "Edit Entity" }
        let!(:page_heading) {"Edit Entity " + entity.name}
        
        describe 'should have a page heading for editing the correct entity' do
          it { should have_content(page_heading) }
        end
      end
      
      describe "who don't own the current facility" do
         let(:non_owner) { FactoryGirl.create(:user) }
         before do 
           sign_in non_owner
           visit entity_path(entity)
         end 
         
         describe "should not see the edit and delete buttons" do
           it { should_not have_button('Edit Entity') }
           it { should_not have_button('Delete Entity') }
         end 

      end
      
      # describe "should show correct associations" do
        # before { FactoryGirl.create(:sample_set, owner: user, facility: facility, num_samples: 20 ) }
#         
        # describe "when showing the samples belonging to this facility" do
          # let!(:first_sample_id) { facility.samples.first.id }
          # let!(:last_sample_id) { facility.samples.last.id }
          # before { visit facility_path(facility) }
          # it { should have_content('Samples associated with this facility') }
          # it { should have_selector('table tr th', text: 'Sample ID') } 
          # it { should have_selector('table tr td', text: first_sample_id) } 
          # it { should have_selector('table tr td', text: last_sample_id) } 
        # end
#         
        # describe "when showing the sample sets belonging to this facility" do
          # let!(:first_sample_set_id) { facility.sample_sets.first.id }
          # let!(:last_sample_set_id) { facility.sample_sets.last.id }
          # before { visit facility_path(facility) }
          # it { should have_content('Sample Sets associated with this facility') }
          # it { should have_selector('table tr th', text: 'Sample Set ID') } 
          # it { should have_selector('table tr td', text: first_sample_set_id) } 
          # it { should have_selector('table tr td', text: last_sample_set_id) } 
        # end
#       
      # end
    
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit entity_path(entity) }
        it { should have_title('Sign in') }
        it { should_not have_button('Edit Entity') }
        it { should_not have_button('Delete Entity') }
      end
    end
    
  end
  
  
  describe "New page" do
    
    describe "for signed-in users" do
    
      before { sign_in user }
      before { visit new_entity_path }
      
      it { should have_content('New Entity') }
      it { should have_title(full_title('New Entity')) }
      it { should_not have_title('| Home') }
      
      describe "with invalid information" do
  
        it "should not create a entity" do
          expect { click_button "Submit" }.not_to change(Entity, :count)
        end
  
      end
  
      describe "with valid information" do
  
        before do
          fill_in 'entity_name', with: 'Facility' 
          fill_in 'entity_exposeAs', with: 'Facility'
        end
        
        it "should create a entity" do
          expect { click_button "Submit" }.to change(Entity, :count).by(1)
        end
        
        describe "should return to view page" do
          before { click_button "Submit" }
          it { should have_content('Entity created!') }
          it { should have_title(full_title('Entity View')) }
        end
        
      end
      
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit new_entity_path }
        it { should have_title('Sign in') }
      end
    end
    
  end
  
  
  describe "entity destruction" do
    let!(:entity) { FactoryGirl.create(:entity, creator: user, name: 'SomeEntity') }

    describe "as correct user" do
      before { sign_in user }
      before { visit entity_path(entity) }

      it "should delete a entity" do
        expect { click_button "Delete Entity" }.to change(Entity, :count).by(-1)
      end
    end
  end
  
  
  describe "edit page" do
    
    let!(:entity) { FactoryGirl.create(:entity, creator: user, name: 'SomeEntity') }
    
    describe "for signed-in users" do
    
      before { sign_in user }
      before { visit edit_entity_path(entity) }
      
      it { should have_content('Edit Entity ' + entity.name) }
      it { should have_title(full_title('Edit Entity')) }
      it { should_not have_title('| Home') }
      
      describe "with invalid information" do
        
          before do
            fill_in 'entity_name', with: ''
            click_button "Update"
          end
          
          describe "should return an error" do
            it { should have_content('error') }
          end
  
      end
  
      describe "with valid information" do
  
        before do
          fill_in 'entity_name'  , with: 'SomeOtherEntity'
          fill_in 'entity_exposeAs'   , with: 'Some other Entity'
        end
        
        it "should update, not add a entity" do
          expect { click_button "Update" }.not_to change(Entity, :count).by(1)
        end
        
        describe "should return to view page" do
          before { click_button "Update" }
          it { should have_content('Entity updated') }
          it { should have_title(full_title('Entity View')) }
        end
      
      end
      
    end
    
    describe "for non signed-in users" do
      describe "should be redirected back to signin" do
        before { visit edit_entity_path(entity) }
        it { should have_title('Sign in') }
      end
    end
  end
  
end