#-*- coding: utf-8 -*-
require 'date'
require 'time'
require 'active_record'
require 'mysql2'
require 'twitter'
require './twitter/conf'
require './conf/db'

keyword_list = {}
query = %q{select id, word from user_keyword}
results = $db_client.query(query)
results.each do |row|
	keyword_list[row['word']] = row['id']
end

query = %q{select uid, text from twitter}
tweet_results = $db_client.query(query)
tweet_results.each do |str_row|
	keyword_ids = [] 
	text = str_row['text']
	keyword_list.each do |key, value|
		keyword_ids.push(value.to_s) if text.include?(key)
	end
	value = keyword_ids.join(',')
	next if value == "1"
	uid = str_row['uid']
	update_sql = %{update twitter set user_keyword_ids=?, updated_at=? where uid=?}
	stmt = $db_client.prepare(update_sql)
	stmt.execute value, Time.now.to_i, uid
end
