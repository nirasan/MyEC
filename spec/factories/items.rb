FactoryGirl.define do
  factory :item do
    sequence(:name) { |i| "item#{i}" }
    price "9.99"
    description "MyText"
    show_flag true
    show_priority 1
  end

end
