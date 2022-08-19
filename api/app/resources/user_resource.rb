class UserResource
  include Alba::Resource

  root_key :user, :users

  attributes :id, :email, :name, :avatar, :created_at, :updated_at
  transform_keys :lower_camel
end