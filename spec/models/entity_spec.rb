require 'spec_helper'

describe Entity do

  let(:creator) { FactoryGirl.create(:user) }
  before { @entity = creator.entities.build(name: "Facility", exposeAs: "Facility", freetext: true) }

  subject { @entity }
  
  it { should respond_to(:name) }
  it { should respond_to(:exposeAs) }
  it { should respond_to(:freetext) }
  it { should respond_to(:creator_id) }
  its(:creator) { should eq creator }

  it { should be_valid }

  describe "when creator_id is not present" do
    before { @entity.creator_id = nil }
    it { should_not be_valid }
  end
  
  describe "when name is not present" do
    before { @entity.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @entity.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when name is already taken" do
    before do
      entity_with_same_name = @entity.dup
      entity_with_same_name.save
    end

    it { should_not be_valid }
  end
end