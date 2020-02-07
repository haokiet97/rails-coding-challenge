FactoryGirl.define do

  sequence(:email) { |n| "test.email#{n}@testdomain.com" }

  factory :contact do
    first_name "John"
    last_name "Smith"
    email # Generate from the sequence
    street_address "123 Evergreen Terrace"
    city "Springfield"
    state "Massachusetts"
    post_code "12345"
    country "USA"
    phone_1 "12345"
    phone_1_label "work"
    phone_2 "67890"
    phone_2_label "home"
  end

  factory :note do
    subject { FactoryGirl.create(:contact) }
  end

end