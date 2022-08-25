class SentenceResource
  include Alba::Resource

  root_key :sentence, :sentences

  attributes :id, :title, :body, :status, :male_speech, :female_speech, :created_at, :updated_at
  transform_keys :lower_camel
end
