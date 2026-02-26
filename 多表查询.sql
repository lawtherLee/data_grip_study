use my_db_01;

# 创建hero表
create table hero
(
hid int primary key,
hname varchar(255),
kongfu_id int
);
# 创建kongfu表
create table kongfu
(
kid int primary key,
kname varchar(255)
);

insert into hero
values (1, '鸠摩智', 9),
       (3, '乔峰',1),
       (4, '虚竹', 4),
       (5, '段誉', 12);

insert into kongfu
values (1, '降龙十八掌'),
       (2, '乾坤大挪移'),
       (3, '猴子偷桃'),
       (4, '天山折梅手');

# 内连接 查询结果 = 表的交集
select * from hero h join kongfu kf on h.kongfu_id = kf.kid;
select * from hero h, kongfu kf where h.kongfu_id = kf.kid; # 效果同上

# 外连接 表的差集
select * from hero h left join kongfu kf on h.kongfu_id = kf.kid; #左表全 右表交集
select * from hero h right join kongfu kf on h.kongfu_id = kf.kid; #右表全 左表交集
