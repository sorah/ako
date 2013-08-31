FactoryGirl.define do
  factory :sub_category do
    name "sub_category"
    order 0

    association :category
  end
end
