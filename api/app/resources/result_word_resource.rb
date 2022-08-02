class ResultWordResource
  include Alba::Resource

  attributes :id, :word, :created_at, :updated_at

  transform_keys :lower_camel
end
