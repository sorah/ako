# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill do
    amount 1
    title "MyString"
    billed_at "2014-03-09 07:18:44"
    meta "MyText"
    place_id ""
    account_id ""
    payment_id ""
  end
end
