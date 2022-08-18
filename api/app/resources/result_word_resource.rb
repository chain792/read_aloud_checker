class ResultWordResource
  include Alba::Resource

  root_key :word, :words

  attributes :id, :position, :result, :created_at, :updated_at

  transform_keys :lower_camel
end
