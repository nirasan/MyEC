FactoryGirl.define do
  factory :admin do
    sequence(:email) { |i| "admin#{i}@example.com" }
    sequence(:password) { |i| "password#{i}" }
  end
end
