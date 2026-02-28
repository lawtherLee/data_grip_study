/*
 常用的窗口函数
    排序类: row_number rank dense_rank ntile(n)
    聚合类: count sum avg max min
    其他类: first_value last_value lag lead
 */

create table employee
(
    empid  int,
    ename  varchar(20),
    deptid int,
    salary
           decimal(10, 2)
);
insert into employee
values (1,
        '刘备'
           , 10, 5500.00),

       (2,
        '赵云'
           , 10, 4500.00),

       (2,
        '张飞'
           , 10, 3500.00),

       (2,
        '关羽'
           , 10, 4500.00),

       (3,
        '曹操'
           , 20, 1900.00),

       (4,
        '许褚'
           , 20, 4800.00),

       (5,
        '张辽'
           , 20, 6500.00),

       (6,
        '徐晃'
           , 20, 14500.00),

       (7,
        '孙权'
           , 30, 44500.00),

       (8,
        '周瑜'
           , 30, 6500.00),

       (9,
        '陆逊'
           , 30, 7500.00);

show tables ;

alter table employee change empid id int ;

select * from employee;
# ------------------------------排序窗口函数------------------------------------
# 分组排名 按照部门工资降序排 partition by 写了就是统计组 不写统计全表
select *,
       row_number() over (partition by employee.deptid order by employee.salary) rn,
       rank() over (partition by employee.deptid order by employee.salary) rk,
       dense_rank()  over (partition by employee.deptid order by employee.salary) dr
from employee;

# 求top n
# 方式1 套表
select *
from (select *, row_number() over (partition by employee.deptid order by employee.salary) rn
      from employee) t1
where rn <= 2;
# 方式2 CTN表达式 with语句
with t1 as (select *, row_number() over (partition by employee.deptid order by employee.salary) rn
            from employee)
select *
from t1
where rn <= 2;

# ------------------------------聚合窗口函数------------------------------------
select *, sum(employee.salary) over(partition by deptid order by salary) sum from  employee;

# 统计员工工资占比 部门工资占比 总工资占比
with t1 as (select *,
                   sum(salary) over (partition by deptid) dept_salary,
                   sum(salary) over ()                    total_salary
            from employee)
select *,
       round(salary / dept_salary, 2)  dept_ratio,
       round(salary / total_salary, 2) total_ratio
from t1;

# ------------------------------其他窗口函数------------------------------------
# 应用场景 数据抽样
select *,
       ntile(2) over (partition by employee.deptid) ntile_val,
       lag(salary, 2) over(partition by deptid) lag_val #当前行往上数2个 lead 往下数
from employee