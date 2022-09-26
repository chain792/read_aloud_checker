class UserResource
  include Alba::Resource

  root_key :user, :users

  attributes :id, :email, :email_status, :name, :avatar, :listening_sex, :role
  attribute :created_at do |resource|
    I18n.l resource.created_at, format: :long
  end
  attribute :updated_at do |resource|
    I18n.l resource.updated_at, format: :long
  end

  transform_keys :lower_camel
end