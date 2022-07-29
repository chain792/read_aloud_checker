module Scraping
  class NewsUSA
    def self.scrape
      url = 'https://www.copyrightfreecontent.com/'
      html = URI.open(url).read
      doc = Nokogiri::HTML.parse(html)
      news = []
      doc.css('#content > div').each do |div|
        break if div.attribute('class').value == 'navigation'
        title = div.at_css('h1 > a').text
        body = div.at_css('.entry > p').text.gsub(/\(NewsUSA\)\W*/,'')
        category = div.at_css('h1 > a').attribute('href').value.gsub(url, '').gsub(/\/.*/, '')
        news << { title: title, body: body, category: category }
      end
      news
    end
  end
end