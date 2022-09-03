class RestrictedUserResource
  include Alba::Resource

  root_key :user, :users

  attributes :id, :name, :avatar, :created_at, :updated_at
  transform_keys :lower_camel
end
