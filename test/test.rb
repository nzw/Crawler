#-*- coding: utf-8 -*-
require 'time'
require 'active_record'
require 'twitter'
require '../twitter/conf'

# キーワード抽出
keywords = "キーワード"
twitter_client = Twitter::REST::Client.new($twitter_token_config)
twitter_client.search(keywords, conut: 10).each {|tweet|
	created_at = tweet.created_at.to_s
	p Time.parse(created_at.sub!(/\s\+\d+/, "")).to_i
}
