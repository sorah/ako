# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill do
    amount 100
    title "shop:2014030901"
    billed_at Time.now
    meta("test" => "value")

    # place_id ""
    # account_id ""
    # expense_id ""
  end
end
