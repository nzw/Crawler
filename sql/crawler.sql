create table if not exists `user_keyword` (
	`id` int unsigned not null auto_increment,
	`type` tinyint not null default 1,
	`word` text,
	`updated_at` int,
	`created_at` int,
	primary key(`id`),
	index(id,type)
) engine=InnoDB DEFAULT CHARSET=utf8;
insert into user_keyword (word, created_at) value ('キーワード1', UNIX_TIMESTAMP());
insert into user_keyword (word, created_at) value ('キーワード2', UNIX_TIMESTAMP());
insert into user_keyword (word, created_at) value ('キーワード3', UNIX_TIMESTAMP());
create table if not exists `twitter` (
	`id` BIGINT unsigned not null auto_increment,
	`user_keyword_id` int,
	`uid` BIGINT,
	`user_name` text,
	`text` text,
	`geo` varchar(100),
	`retweet_count` text,
	`favorite_count` text,
	`created_at` int(10),
	primary key(`id`),
	index(id, user_keyword_id)
) engine=InnoDB DEFAULT CHARSET=utf8;
