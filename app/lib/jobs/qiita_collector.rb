require 'qiita'
require_relative '../models/article'

module Jobs
  class QiitaCollector
    def run
      c = Qiita::Client.new
      target_day = Time.now.to_date - 7

      1.upto(10) do |page|
        # Qiitaから1週間前の記事を取得する
        puts "qiita search!"
        response = c.list_items({page: page, per_page: 100, query: "created:#{target_day}"})
        if response.body.empty?
          # 記事が一件も取得できない場合はそれ以降のページに記事は無いため終了する
          puts "Finish!"
          break
        end

        # 記事を精査する
        puts "selecting..."
        checked = response.body.select do |body|
          body["likes_count"] >= 30
        end

        # Googleスプレッドシートに保存する
        puts "save..."
        checked.each do |item|
          t = Time.now
          article = Models::Article.new
          article.id = item['id']
          article.title = item['title']
          article.url = item['url']
          item['tags'].each.with_index(1) do |tag, i|
            article.send("tag#{i}=", tag['name'])
          end
          article.likes_count = item['likes_count']
          article.notify_status = Models::Article::NotifyStatus::NOT_NOTIFY
          article.created_at = t
          article.updated_at = t
          article.create
        end

        sleep(3)
      end
    end
  end
end