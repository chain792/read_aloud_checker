class TrainingResource
  include Alba::Resource

  attributes :id, :sentence_id, :voice, :word_count, :created_at, :updated_at

  transform_keys :lower_camel

  many :result_words, resource: ResultWordResource
end
