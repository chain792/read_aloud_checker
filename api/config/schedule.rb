
require File.expand_path(File.dirname(__FILE__) + "/environment")

# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :production
# cronを実行する環境変数をセット
set :environment, rails_env
# 実行logの出力先
set :output, "#{Rails.root.to_s}/log/cron.log"


job_type :rake, "source ~/.zshrc; export PATH=\"$HOME/.rbenv/bin:$PATH\"; eval \"$(rbenv init -)\"; cd :path && RAILS_ENV=:environment bundle exec rake :task :output"

every :sunday, at: '4:00 am' do
  rake 'scraping:scrape_news_usa'
end