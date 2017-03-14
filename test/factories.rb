FactoryGirl.define do 
  factory :user do
    username "foo"
    password "foobar"
    password_confirmation { |u| u.password }
    email "foo@example.com"
  end
end