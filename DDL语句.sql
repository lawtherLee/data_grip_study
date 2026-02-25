# -----------------------------DDL（库表基本操作）------------------------------------
show databases;

# 创建数据库
create database if not exists day01 charset 'utf8';
create database if not exists day02 charset 'utf8';

# 查看数据库信息
show create database if not exists my_db_01;


drop database day02;



use day01;

# 创建表字段
create table if not exists users
(
    id       int,
    username varchar(20),
    password varchar(20)
);

show tables;

# 查看表字段详情
desc users;

# 删表
drop table users;

# 给表加字段
alter table users
    add address int not null;

# 修改表字段
alter table users
    modify address varchar(10) not null;

# 修改字段名
alter table users
    change address addr varchar(20) not null;

# 删除表字段
alter table users
    drop addr;


