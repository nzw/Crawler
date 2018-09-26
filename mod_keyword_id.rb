#-*- coding: utf-8 -*-
require 'active_record'
require 'mysql2'
require '../twitter/conf'
require './conf/db'

key_query = %q{select id, word from user_keyword}
results = $db_client.query(key_query)
results.each do |row|
	p row
end
