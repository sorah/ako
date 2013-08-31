FactoryGirl.define do
  factory :payment do
    amount 100
    comment "Hello"
    meta "a" => "b"
    paid_at Time.now
    fixed false

    association :sub_category
    # TODO: place
    # TODO: billing
    # TODO: account
  end
end
