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


insert into product(pid, pname, price, category_id)
values (1,
        '联想'
           , 5000,
        '
        c001');
insert into product(pid, pname, price, category_id)
values (2,
        '海尔'
           , 3000,
        '
        c001');
insert into product(pid, pname, price, category_id)
values (3,
        '雷神'
           , 5000,
        '
        c001');
insert into product(pid, pname, price, category_id)
values (4,
        '杰克琼斯'
           , 800,
        '
        c002');
insert into product(pid, pname, price, category_id)
values (5,
        '真维斯'
           , 200,
        '
        c002');
insert into product(pid, pname, price, category_id)
values (6,
        '花花公子'
           , 440,
        '
        c002');
insert into product(pid, pname, price, category_id)
values (7,
        '劲霸'
           , 2000,
        '
        c002');
insert into product(pid, pname, price, category_id)
values (8,
        '香奈儿'
           , 800,
        '
        c003');
insert into product(pid, pname, price, category_id)
values (9,
        '相宜本草'
           , 200,
        '
        c003');
insert into product(pid, pname, price, category_id)
values (10,
        '面霸'
           , 5,
        '
        c003');
insert into product(pid, pname, price, category_id)
values (11,
        '好想你枣'
           , 56,
        '
        c004');
insert into product(pid, pname, price, category_id)
values (12,
        '香飘飘奶茶'
           , 1,
        '
        c005');
insert into product(pid, pname, price, category_id)
values (13,
        '海澜之家'
           , 1,
        '
        c002');

