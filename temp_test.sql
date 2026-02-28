create database temp_test;

use temp_test;

create table user_info
(
    id int primary key auto_increment comment '自增id',
    uid int not null unique comment '用户id',
    nick_name varchar(64) comment '昵称',
    achievement int not null default 0 comment '成就值',
    level int comment '用户等级',
    job varchar(32) comment '职业方向',
    register_time datetime default current_timestamp comment '注册时间'
) ;


alter table user_info
    add school varchar(45) comment '学校' after level,
    change job profession varchar(10) comment '职业方向',
    modify achievement int not null default 0 comment '成就值';

desc user_info;
drop database temp_test;

# ------------------------------------------------------------------------

create table if not exists computers
(
    id            int auto_increment primary key,
    name          varchar(200) not null comment '电脑的名字',
    brand         varchar(50)  not null comment '电脑的品牌',
    cpu           varchar(100) not null comment '电脑处理器CPU',
    video_card    varchar(100) null comment '电脑的显卡',
    color         varchar(50)  not null comment '电脑的颜色',
    memory        varchar(100) not null comment '电脑的运行内存',
    disk          int          not null comment '电脑的硬盘空间 单位是GB',
    weight        float        not null comment '电脑的重量,单位是千克',
    classify_type int          not null comment '电脑的分类: 1. 笔记本 2. 台机 3. 工业电脑',
    price         float        not null comment '电脑的价格'
);
insert into computers
values (null,'拯救者R9000P','联想','R7-5800H','RTX3060','黑色',16,512,2.58,1,8099),
     (null,'华硕天选3','华硕','i7-12700H','RTX3060','蓝色',16,512,4.15,1,8699),
     (null,'宏碁新暗影骑士·擎','宏碁','i5-12500H','RTX3050','黑色',16,512,2.5,1,6569),
     (null,'外星人ALIENWARE 2022','戴尔','i7-12700H','RTX3050','黑色',16,512,3.77,1,12499),
     (null,'ROG幻16 2022','华硕','i9-12900H','RTX3080Ti','银白色',32,1024,4.15,1,21999),
     (null,'联想拯救者Y9000K 2022','联想','i7-12800HX','RTX3070Ti','黑色',32,1024,5.1,1,17999),
     (null,'戴尔（DELL）13pro灵越5320','戴尔','i7-1260P','集成显卡','银白色',16,512,2.05,1,7699),
     (null,'联想小新Air14','联想','i5-1155G7','集成显卡','粉色',8,256,2.2,1,3299),
     (null,'惠普(HP)星13','惠普','i5-1155G7','集成显卡','粉色',16,512,1.3,1,4399),
     (null,'Apple MacBook Air','苹果','M2芯片','M2集成显卡','银白色',8,256,2.37,1,9499),
     (null,'外星人（alienware）Aurora R13','戴尔','i9-12900KF','RTX-3080Ti','黑色',64,2048,24,2,39298),
     (null,'宏碁(Acer) 暗影骑士·威N93','宏碁','i5-12400F','GTX1660S','黑色',16,512,7.64,2,6299),
     (null,'联想（ThinkStation）P920','联想','xeon至强处理器','P6000','黑色',256,122888,19,3,98699),
     (null,'惠普(HP)暗影精灵8Plus','惠普','i7-12700H','RTX3080Ti','黑色',16,1024,4.99,1,14999);

# 1. 查询 CPU 是 i7-12700H、显卡是 RTX3060 的电脑
select * from computers where cpu = 'i7-12700H' and video_card = 'RTX3060';
# 2. 查询 CPU 是 i7、硬盘空间是 1T 的所有电脑
select * from computers where cpu like '%i7%' and disk = 1024;
# 3. 查询 CPU 是 i7 或者 CPU 是 i9 的电脑信息
select * from computers where cpu regexp 'i7|i9';
# 4. 查询 CPU 是 i7 或者 显卡是 RTX3060 的电脑
select * from computers where cpu like 'i7%' or video_card = 'RTX3060';
# 5. 查询 CPU 不是 i7 的所有电脑
select * from computers where cpu not regexp('i7');
# 6. 查询 CPU 是 i7 或者 i9、显卡是 RTX3080Ti、颜色不是粉色的笔记本电脑
select * from computers where cpu regexp 'i7|i9' and video_card = 'RTX3080Ti' and color != '粉色' and classify_type = 1;