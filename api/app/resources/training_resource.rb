class TrainingResource
  include Alba::Resource

  root_key :training, :trainings

  attributes :id, :sentence_id, :voice, :created_at, :updated_at
  transform_keys :lower_camel

  many :result_words, resource: ResultWordResource
  one :sentence, resource: SentenceResource
end
