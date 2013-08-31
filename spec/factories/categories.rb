FactoryGirl.define do
  factory :category do
    name "category"
    budget 10000
    order 0
    fixed false

    trait :with_sub_categories do
      ignore do
        sub_categories_count 5
      end

      after(:create) do |category, evaluator|
        evaluator.sub_categories_count.each do |i|
          FactoryGirl.create(:sub_category, name: "sub_category#{i}", order: i)
        end
      end
    end
  end
end
