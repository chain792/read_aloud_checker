class SentenceResource
  include Alba::Resource

  attributes :id, :title, :body, :status, :created_at, :updated_at

  transform_keys :lower_camel
end
