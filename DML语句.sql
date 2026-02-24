# -----------------------------DML（表数据增删改操作）------------------------------------

use day01;

show tables;

drop table if exists stu;
select *
from day01.users;
select *
from stu;

insert into users(id, username, password)
values ('1', 'zs', '123');


insert into users
values (1, 'ls', '2222'),
       (33, 'ww', '442');

create table stu
(
    id     int primary key auto_increment,
    name   varchar(10) not null,
    tel    varchar(11) unique,
    gender varchar(1) default '男'

);

# 新增表数据
insert into stu
values (null, '乔峰', '111', '');

insert into stu (id, name, tel)
values (null, '阿朱', '222');

# 更新表数据
update stu
set gender='男'
where id = 1;

#删除
delete
from stu
where id = 1;

delete
from stu;

truncate stu; # DDL语句,不包含事务,id会清空 摧毁表重建