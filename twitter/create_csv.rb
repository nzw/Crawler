#-*- coding: utf-8 -*-
require 'date'
require 'time'
require 'active_record'
require './conf/token'
require './conf/db'

csv_file = "ツイートID, 名前, 本文, ツイート日時, 位置情報, DB取得日時, \n"
query = %q{select uid, user_name, text, tweet_created_at, geo, created_at from twitter}
tweet_results = $db_client.query(query)
LAST_KEY_NAME = "tweet_created_at"
tweet_results.each do |row|
	_csv_file = [];
	row.each do |key, value|
		if !value || value == "0" then
			_csv_file.push("---")
			next
		end

		case key
		when "uid" then
			value = value.to_s
			_csv_file.push(value.gsub(/^/, ':'))
		when "user_name", "text" then
			value = value.to_s
			value = value.gsub(/(\r\n|\r|\n)/, '{＼n}')
			_csv_file.push(value.gsub(/(,)/, '{カンマ}'))
		when "tweet_created_at", LAST_KEY_NAME then
			_csv_file.push(Time.at(value).to_s)
		else
			_csv_file.push(value.to_s)
		end
	end
	csv_file += _csv_file.join(',')
	csv_file += ",\n"
end
d = Date.today
today = d.year.to_s + d.month.to_s + d.day.to_s
file_name = "/home/ec2-user/csv/tweet_list_" + today.to_s  + ".csv"    #保存するファイル名
File.open(file_name, 'w') {|file|
	file.write csv_file.encode("Shift_JIS", "UTF-8", :invalid => :replace, :undef => :replace)
}
