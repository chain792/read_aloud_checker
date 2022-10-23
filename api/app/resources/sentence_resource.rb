class SentenceResource
  include Alba::Resource

  root_key :sentence, :sentences

  attributes :id, :title, :body, :status, :male_speech, :female_speech, :creater_type, :creater_id, :created_at, :updated_at, :word_count
  transform_keys :lower_camel
end
