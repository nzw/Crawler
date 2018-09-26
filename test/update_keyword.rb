#-*- coding: utf-8 -*-
require 'time'
require 'active_record'
require 'mysql2'
require 'twitter'
require '../twitter/conf'
require './conf/db'

# キーワード抽出
hash_key = ""
keyword_list = {}
keyword_query = %q{select id, word from user_keyword}
keyword_results = $db_client.query(keyword_query)
keyword_results.each do |row|
	row.each do |key, value|
		if key == 'id'
			hash_key = value
		elsif key == 'word' then
			keyword_list[hash_key] = value
			hash_key = ""
		end
	end
end
p keyword_list
query = %q{select text from twitter}
twitter_results = $db_client.query(query)
twitter_results.each do |row|
end
