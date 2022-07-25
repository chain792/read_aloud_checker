require_relative '../scraping/news_usa'

namespace :scraping do
  desc 'NewsUSAから英文を取得する'
	task scrape_news_usa: :environment do
    pp news_articles = Scraping::NewsUSA.scrape
	end
end