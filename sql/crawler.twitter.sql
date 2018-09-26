create table if not exists `twitter` (
    `id` BIGINT unsigned not null auto_increment,
    `user_keyword_id` int,
    `uid` BIGINT,
    `user_name` text,
    `text` text,
    `geo` varchar(100),
    `retweet_count` text,
    `favorite_count` text,
    `created_at` varchar(30),
    primary key(`id`),
    index(id, user_keyword_id)
) engine=InnoDB DEFAULT CHARSET=utf8;
