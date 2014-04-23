FactoryGirl.define do
  factory :user do
    sequence(:firstname)  { |n| "Person #{n}" }
    sequence(:surname)  { |n| "Bla Bla #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"  
    
    factory :admin do
      admin true
    end
  end
  
  factory :entity do
    name "Facility"
    exposeAs  "FacilityText"
    freetext true
    association :creator, :factory  => :user
  end
  
end