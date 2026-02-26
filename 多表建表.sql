# ---------------------------多表建表-------------------------
show databases ;

use my_db_01;

show tables ;

drop table dept;

create table if not exists dept(
    id int primary key auto_increment,
    name varchar(10)
);

create table emp(
    id int primary key auto_increment,
    name varchar(4),
    #建表时添加外键
    dept_id int
#     , constraint fk_dept_emp foreign key(dept_id) references dept(id)
);

# 建表后添加外键
delete from emp where id = 4;

# 删除外键
alter table emp drop foreign key fk_01;
alter table emp add constraint fk_01 foreign key(dept_id) references dept(id);


insert into dept (id, name)
values (null,'人事部'), (null,'研发部'),(null,'市场部');

insert into emp (id, name, dept_id)
values (null, '乔峰', 1),
       (null, '段誉', 2),
       (null, '虚竹', 3);

select * from dept;
select * from emp;
