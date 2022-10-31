class NewsResource
  include Alba::Resource

  root_key :news, :news

  transform_keys :lower_camel
end
