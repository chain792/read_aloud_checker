class ResultWordResource
  include Alba::Resource

  root_key :word, :words

  attributes :id, :word, :created_at, :updated_at

  transform_keys :lower_camel
end
