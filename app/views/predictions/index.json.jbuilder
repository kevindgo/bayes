json.array!(@predictions) do |prediction|
  json.extract! prediction, :id, :product, :tag
  json.url prediction_url(prediction, format: :json)
end
