# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :place do
    # http://nanohack.net/pilgrimage/lovelive_bunkyou_ku/
    name "maki-chan-no-tsugakuro"
    foursquare_venue_id nil
    latitude 35.709653
    longitude 139.764283
  end
end
