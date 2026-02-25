show databases;

use my_db_01;

show tables;

create table product
(
    pid         int primary key,
    pname       varchar(20),
    price       double,
    category_id varchar(32)
);

alter table product
    modify pid int auto_increment;

desc product;

truncate product;

select * from product;

insert into product(pid,pname,price,category_id) values(1,'联想',5000,'c001');
insert into product(pid,pname,price,category_id) values(2,'海尔',3000,'c001');
insert into product(pid,pname,price,category_id) values(3,'雷神',5000,'c001');
insert into product(pid,pname,price,category_id) values(4,'杰克琼斯',800,'c002');
insert into product(pid,pname,price,category_id) values(5,'真维斯',200,'c002');
insert into product(pid,pname,price,category_id) values(6,'花花公子',440,null);
insert into product(pid,pname,price,category_id) values(7,'劲霸',2000,'c002');
insert into product(pid,pname,price,category_id) values(8,'香奈儿',800,'c003');
insert into product(pid,pname,price,category_id) values(9,'相宜本草',200,'c003');
insert into product(pid,pname,price,category_id) values(10,'面霸',5,null);
insert into product(pid,pname,price,category_id) values(11,'好想你枣',56,'c004');
insert into product(pid,pname,price,category_id) values(12,'香飘飘奶茶',1,'c005');
insert into product(pid,pname,price,category_id) values(13,'海澜之家',1,'c002');

# 别名
select pname as 商品名称, price as 商品价格 from product;
select product.pname as 商品名称, product.price  商品价格 from product;
select price ,product.price + 10 price from product;

# ---------------------------------------条件查询----------------------------------------

# 查询商品名称为“花花公子”的商品所有信息：
select * from product where pname = '花花公子';
# 查询价格为800商品
select * from product where price = 800;
# 查询价格不是800的所有商品
select * from product where price != 800;
select * from product where price <> 800;
select * from product where not price = 800;
select * from product where price not in(800);
# 查询商品价格大于60元的所有商品信息
select * from product where price > 60;
# 查询商品价格小于等于800元的所有商品信息
select * from product where price <= 800;
# 查询商品价格在200到1000之间所有商品

# ---------------------------------------逻辑查询----------------------------------------

select * from product where price between 200 and 1000;
select * from product where price >= 200 and price <= 800;
# 查询商品价格在200或1000的商品
select * from product where price in (200,800);
select * from product where price = 200 or price = 800;

# ---------------------------------------模糊查询----------------------------------------

# 查询以'香'开头的所有商品
select * from product where pname like '香%';
# 查询第二个字为'想'的所有商品
select * from product where pname like '_想%';

# ---------------------------------------非空查询----------------------------------------

# 查询没有分类的商品
select * from product where category_id is null;
# 查询有分类的商品
select * from product where category_id is not null;

# ---------------------------------------排序查询----------------------------------------

# 1.使用价格排序(降序)
select * from product order by price desc;
# 2.在价格排序(降序)的基础上，以分类排序(降序)
select * from product order by price desc,category_id desc ;

# ---------------------------------------聚合查询----------------------------------------

# 1、查询商品的总条数
select count(*) from product;
# 2、查询价格大于200商品的总条数
select count(*) from product where price > 200;
# 3、查询分类为'c001'的所有商品的总和
select sum(price) from product where category_id = 'c001';
# 4、查询分类为'c002'所有商品的平均价格
select avg(price) from product where category_id = 'c002';
# 5、查询商品的最大价格和最小价格
select
    max(price) as max_price,
    min(price) as min_price
from
    product;
# ---------------------------------------分组查询----------------------------------------

#1 统计各个分类商品的个数
select category_id, count(*)
from product
group by category_id;
#2 统计各个分类商品的个数,且只显示个数大于1的信息
SELECT category_id, COUNT(*)
FROM product
GROUP BY category_id
HAVING COUNT(*) > 1;

#3 根据分组实现去重
select category_id from product group by category_id;
#4 其他去重
select distinct product.category_id from product;

# ---------------------------------------分页查询----------------------------------------
/*
 总条数: count函数
 每页起始索引: (当前页数 - 1) * 每页条数
 总页数: (数据总条数 + 每页条数 - 1) // 每页条数

 */
select * from product limit 3;    # 0可省略
select * from product limit 3, 3; # 第二页
select * from product limit 6, 3; # 第三页
select * from product limit 9, 3; # 第四页
