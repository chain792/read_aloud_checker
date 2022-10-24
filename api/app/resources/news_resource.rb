class NewsResource
  include Alba::Resource

  root_key :news, :news

  attribute :category do |resource|
    resource.news_category.name
  end
  transform_keys :lower_camel
end
