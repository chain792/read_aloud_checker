class TrainingResource
  include Alba::Resource

  root_key :training, :trainings

  attributes :id, :sentence_id, :title, :body, :male_speech, :female_speech, :voice, :created_at, :updated_at
  transform_keys :lower_camel

  many :result_words, resource: ResultWordResource
end
