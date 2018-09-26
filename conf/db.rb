#-*- coding: utf-8 -*-
require 'mysql2'

username = ''
password = ''
database = ''
$db_client = Mysql2::Client.new(:host => "localhost", :username => username, :passwd => password, :database => database)
