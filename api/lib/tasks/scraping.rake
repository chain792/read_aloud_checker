require_relative '../scraping/news_usa'

namespace :scraping do
  desc 'NewsUSAから英文を取得する'
  task scrape_news_usa: :environment do
    news_articles = Scraping::NewsUSA.scrape(1)

    news_articles.each do |news_article|
      category = Category.find_or_create_by!(name: news_article[:category])
      news = News.new(title: news_article[:title])
      next unless news.save

      sentence = news.build_sentence(title: news.title, body: news_article[:body], status: :public_state,
        remote_thumbnail_url: news_article[:thumbnail], categories: [category])
      sentence.save
    end
  end
end
