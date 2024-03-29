class DetailSentenceResource
  include Alba::Resource

  root_key :sentence, :sentences

  attributes :id, :title, :body, :status, :male_speech, :female_speech, :created_at, :updated_at,
    :creater_type, :creater_id
  transform_keys :lower_camel

  many :bookmarks do
    attributes :user_id
    transform_keys :lower_camel
  end

  one :creater, key: 'user', resource: RestrictedUserResource, if: proc { |sentence| sentence.creater_type == 'User' }
end
