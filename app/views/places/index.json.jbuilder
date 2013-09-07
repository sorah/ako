json.array!(@places) do |place|
  json.extract! place, :name, :foursquare_venue_id, :latitude, :longitude
  json.url place_url(place, format: :json)
end
