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
        evaluator.sub_categories_count.times do |i|
          FactoryGirl.create(:sub_category, name: "sub_category#{i}", order: i, category_id: category.id)
        end
      end
    end
  end
end
