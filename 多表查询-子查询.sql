# 一个查询语句的查询条件 需要依赖另一个SQL语句的查询结果
use my_db_01;
# 查询商品表中单价在均价之上的所有商品
select round(avg(price), 2) avg_price from product;
select * from product where price > 1346.38;

# 子查询
select *
from product
where price > (select round(avg(price), 2) avg_price from product);