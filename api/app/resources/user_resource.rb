class UserResource
  include Alba::Resource

  attributes :id, :email, :name, :avatar, :created_at, :updated_at

  transform_keys :lower_camel
end