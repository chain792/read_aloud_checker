module Scraping
  class NewsUSA
    def self.scrape(n)
      base_url = 'https://www.copyrightfreecontent.com/'
      html = URI.parse(base_url + "page/#{n}/").open.read
      doc = Nokogiri::HTML.parse(html)
      news = []
      doc.css('#content > div').each do |div|
        break if div.attribute('class').value == 'navigation'

        body = div.at_css('.entry > p').text.gsub(/\(NewsUSA\)\W*/, '')
        # 長すぎる英文は取得しない
        next unless body.split.length.between?(1, 300)

        title = div.at_css('h1 > a').text
        thumbnail = div.at_css('.entry > p > .category-img').attribute('src').value
        category = div.at_css('h1 > a').attribute('href').value.gsub(base_url, '').gsub(%r{/.*}, '')
        news << { title: title, body: body, category: category, thumbnail: thumbnail }
      end
      news
    end
  end
end
