#-*- coding: utf-8 -*-
require 'date'
require 'time'
require 'active_record'
require 'mysql2'
require 'twitter'
require './twitter/conf/token'
require './conf/db'


# キーワード抽出
keyword_list = []
query = %q{select word from user_keyword}
results = $db_client.query(query)
results.each do |row|
	keyword_list.push(row["word"])
end
keywords = keyword_list.join(' OR ')
puts "keywords => ", keywords

# 既にDBにあるTweetは「１」を渡す
tweet_db_list = {}
query = %q{select uid from twitter}
tweet_results = $db_client.query(query)
tweet_results.each do |row|
	tweet_db_list[row['uid']] = 1
end

max_count = 10000
twitter_client = Twitter::REST::Client.new($twitter_token_config)
twitter_client.search(keywords, conut: max_count).each {|tweet|
=begin
	# Tweet時間
	puts tweet.created_at
	# Tweet本文
	puts tweet.text
	# Retweet数
	puts "Retweetされた数:" + tweet.retweet_count.to_s
	#お気に入りされた数
	puts "お気に入りされた数:" + tweet.favorite_count.to_s
	#位置情報
	puts "位置情報:" + tweet.geo if !tweet.geo.nil?
	# 検索ワードで Tweet を取得できなかった場合の例外処理
	rescue Twitter::Error::ClientError
=end
	tweet_created_at = tweet.created_at.to_s
	tweet_created_at = Time.parse(tweet_created_at.sub!(/\s\+\d+/, "")).to_i
	next if tweet_db_list[tweet.id]
	keyword_ids = [] 
	user_keyword_ids = ""
	keyword_list.each do |key, value|
		keyword_ids.push(value.to_s) if tweet.text.include?(key)
	end
	user_keyword_ids =  keyword_ids.join(',') if keyword_ids
	sql = %{
		insert into twitter (user_keyword_ids, uid, user_name, geo, text, retweet_count, favorite_count, tweet_created_at, updated_at, created_at) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
	}
	puts "sql => ", sql
	stmt = $db_client.prepare(sql)
	stmt.execute user_keyword_ids, tweet.id, tweet.user.name, tweet.geo, tweet.text, tweet.retweet_count.to_s, tweet.favorite_count.to_s, tweet_created_at, Time.now.to_i, Time.now.to_i
}
