require 'spec_helper'

describe Field do

  let(:creator) { FactoryGirl.create(:user) }
  before { @field = creator.fields.build(name: "Address", fieldtype: "Address", uri: "mydomain/address") }

  subject { @field }
  
  it { should respond_to(:name) }
  it { should respond_to(:fieldtype) }
  it { should respond_to(:uri) }
  it { should respond_to(:creator_id) }
  its(:creator) { should eq creator }

  it { should be_valid }

  describe "when creator_id is not present" do
    before { @field.creator_id = nil }
    it { should_not be_valid }
  end
  
  describe "when name is not present" do
    before { @field.name = " " }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @field.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when name is already taken" do
    before do
      field_with_same_name = @field.dup
      field_with_same_name.save
    end

    it { should_not be_valid }
  end
end