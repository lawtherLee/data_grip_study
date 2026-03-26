-- ******************** 准备动作 ********************
-- 1. 创建数据库.
DROP DATABASE north_wind;
CREATE DATABASE north_wind;
-- 我们一会儿要做的34个题用的数据源是从Git上下载的, 微软的北风项目的源数据.

-- 2. 切换数据库.
USE north_wind;

-- 3. 查询所有表.
SHOW TABLES;

-- 4. 导入北风项目的数据源.


-- ******************** 以下是 34个练习题 ********************
-- 需求1: 选中employees 表的所有数据
SELECT *
FROM employees;

-- 需求2: 查询每个客户的 ID, company name, contact name, contact title, city, 和 country.并按照国家名字排序
SELECT customer_id, company_name, contact_name, contact_title, city, country
FROM customers
ORDER BY country;


-- 替换快捷键: ctrl + 字母R
-- 需求3: 查询每一个商品的product_name, category_name, quantity_per_unit, unit_price, units_in_stock 并且通过 unit_price 字段排序
-- 方式1: 显示内连接
SELECT p.product_name,
       c.category_name,
       p.quantity_per_unit,
       p.unit_price,
       p.units_in_stock
FROM products p
         JOIN categories c
              ON p.category_id = c.category_id
ORDER BY unit_price DESC;

-- 方式2: 隐式内连接.
SELECT product_name, category_name, quantity_per_unit, unit_price, units_in_stock
FROM products p,
     categories c
WHERE p.category_id = c.category_id
ORDER BY unit_price DESC;


-- 需求4: 列出所有提供了4种以上不同商品的供应商列表 所需字段：supplier_id, company_name, and products_count (提供的商品种类数量).
# step1: 计算每个供应商, 供应的商品总数.
SELECT p.supplier_id,
       s.company_name,
       COUNT(product_id) products_count
FROM products p
         JOIN suppliers s ON p.supplier_id = s.supplier_id
GROUP BY p.supplier_id, s.company_name;

# step2: 计算每个供应商, 供应的商品总数, 筛选出 提供了4种以上不同商品的 供应商及其供应的商品总数.
SELECT p.supplier_id,
       company_name,                       # 分组字段: 供应商的id, 公司名.
       COUNT(product_id) AS products_count # 计算: 商品的总数
FROM products p
         join
     suppliers s ON p.supplier_id = s.supplier_id
GROUP BY
    # p.supplier_id, company_name      # 根据供应商id, 公司名 分组.
    p.supplier_id, s.company_name # 根据供应商id 分组.
HAVING products_count > 4;

-- 需求5: 提取订单编号为10250的订单详情, 显示如下信息：
-- product_name, quantity, unit_price （ order_items 表), discount , order_date 按商品名字排序
-- 先连接 后筛选
SELECT product_name, quantity, oi.unit_price, discount, order_date
FROM orders o
         JOIN order_items oi ON o.order_id = oi.order_id
         JOIN products p ON p.product_id = oi.product_id
WHERE o.order_id = 10250
ORDER BY p.product_name;
-- 先筛选 后连接
SELECT product_name, quantity, oi.unit_price, discount, order_date
FROM orders o
         JOIN (SELECT * FROM order_items WHERE order_id = 10250) oi ON o.order_id = oi.order_id
         JOIN products p ON p.product_id = oi.product_id
WHERE o.order_id = 10250
ORDER BY p.product_name;


-- 需求6: 收集运输到法国的订单的相关信息，包括订单涉及的顾客和员工信息，下单和发货日期等.
# step1: 找表, 即: 看看结果要用哪些表的字段, 把它们组合成一张表 -> 进行单表查询即可.
SELECT *
FROM employees e
         JOIN orders o ON e.employee_id = o.employee_id
         JOIN customers c ON c.customer_id = o.customer_id;

# step2: 完成题设.
SELECT e.employee_id,
       e.last_name,
       e.first_name,   # 员工:id, 姓名
       c.customer_id,
       c.company_name,
       c.contact_name, # 客户: 公司名缩写, 公司名, 联系人的名字
       o.order_id,
       o.order_date,
       o.shipped_date,
       o.ship_country  # 订单: id, 下单时间, 发船时间, 目的地(国家)

FROM employees e
         LEFT JOIN orders o ON e.employee_id = o.employee_id
         LEFT JOIN customers c ON c.customer_id = o.customer_id
WHERE o.ship_country = 'France';

# step3: 验真.
SELECT *
FROM orders
WHERE ship_country = 'France';
# 77条

-- 需求7: 提供订单编号为10248的相关信息，
-- 包括product name, unit price (在 order_items 表中),
-- quantity（数量）,company_name（供应商公司名字 ，起别名 supplier_name).
SELECT product_name, oi.unit_price, quantity, company_name AS supplier_name
FROM order_items oi
         JOIN products p ON p.product_id = oi.product_id
         JOIN suppliers s ON s.supplier_id = p.supplier_id
WHERE order_id = 10248;

-- 需求8:  提取每件商品的详细信息，包括 商品名称（product_name）, 供应商的公司名称 (company_name，在 suppliers 表中),
-- 类别名称 category_name, 商品单价unit_price, 和每单位商品数量quantity per unit
# 显示内连接
SELECT product_name, company_name, category_name, unit_price, quantity_per_unit
FROM products p
         JOIN suppliers s ON s.supplier_id = p.supplier_id
         JOIN categories c ON c.category_id = p.category_id;
# 隐式内连接
SELECT product_name, company_name, category_name, unit_price, quantity_per_unit
FROM products p,
     categories c,
     suppliers s
WHERE c.category_id = p.category_id
  AND s.supplier_id = product_id;

-- 需求9: 另一种常见的报表需求是查询某段时间内的业务指标, 我们统计2016年7月的订单数量，
# 思路1: 模糊查询
SELECT *
FROM orders
WHERE order_date LIKE '2016-07%';
# 思路2: 范围查询.
SELECT *
FROM orders
WHERE order_date >= '2016-07-01'
  AND order_date <= '2016-07-31';
SELECT *
FROM orders
WHERE order_date BETWEEN '2016-07-01' AND '2016-07-31';
# 思路3: 函数实现.
SELECT YEAR('2016-07-01 00:00:00'); # 获取 年份
SELECT MONTH('2016-07-01 00:00:00'); # 获取 月份
SELECT DAY('2016-07-01 00:00:00'); # 获取 天(月中的第几天)
SELECT *
FROM orders
WHERE YEAR(order_date) = 2016
  AND MONTH(order_date) = 7;

-- 需求11: 统计每个供应商供应的商品种类数量, 结果返回供应商ID supplier_id
-- ，公司名字company_name ，商品种类数量（起别名products_count )使用 products 和 suppliers 表.
# 思路1: 求交集.  如果供应商没有供应商品, 我们就不显示.
SELECT p.supplier_id, s.company_name, COUNT(product_id) as products_count
FROM products p
         JOIN suppliers s ON s.supplier_id = p.supplier_id
GROUP BY p.supplier_id, s.company_name;
# 思路2: 求差集.  即使供应商没有供应商品, 我们也显示这个供应商的信息.
SELECT p.supplier_id, s.company_name, COUNT(product_id) as products_count
FROM products p
         LEFT JOIN suppliers s ON s.supplier_id = p.supplier_id
GROUP BY p.supplier_id, s.company_name;

-- 需求12: 我们要查找ID为10250的订单的总价（折扣前），SUM(unit_price * quantity)
SELECT SUM(unit_price * quantity) AS total_price
FROM order_items
WHERE order_id = 10250;

-- 需求13:  统计每个员工处理的订单总数, 结果包含员工ID employee_id，姓名first_name 和 last_name，
-- 处理的订单总数(别名 orders_count)
# 场景1: 只统计有订单的 员工的情况.   交集: 内连接.
SELECT e.employee_id, e.last_name, e.first_name, COUNT(order_id) AS orders_count
FROM employees e
         JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.last_name, e.first_name;
# 场景2: 查看所有员工的订单总数, 哪怕为0.  差集: 左外连接.
SELECT e.employee_id, e.last_name, e.first_name, COUNT(order_id) AS orders_count
FROM employees e
         LEFT JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.last_name, e.first_name;

-- 需求14: 统计每个类别中的库存产品值多少钱？显示三列：category_id, category_name, 和 category_total_value,
-- 如何计算库存商品总价：SUM(unit_price * units_in_stock)。
SELECT c.category_id, c.category_name, SUM(unit_price * units_in_stock) AS category_total_value
FROM categories c
         JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, category_name;

-- 需求15: 计算每个员工的订单数量
SELECT e.employee_id, e.last_name, e.first_name, COUNT(order_id) AS total_cnt
FROM employees e
         LEFT JOIN orders o ON e.employee_id = o.employee_id
GROUP BY employee_id;


-- 需求16: 计算每个客户的下订单数 结果包含：用户id、用户公司名称、订单数量（customer_id, company_name, orders_count ）
SELECT c.customer_id, c.company_name, COUNT(o.order_id) as orders_count
FROM customers c
         LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- 需求17: 统计2016年6月到2016年7月用户的总下单金额并按金额从高到低排序
-- 结果包含：顾客公司名称company_name 和总下单金额（折后实付金额）total_paid
-- 提示：
-- 计算实际总付款金额： SUM(unit_price quantity (1 - discount))
-- 日期过滤 WHERE order_date >= '2016-06-01' AND order_date < '2016-08-01'
SELECT c.customer_id, c.company_name, SUM(unit_price * quantity * (1 - discount)) AS total_paid
FROM customers c
         JOIN (SELECT * FROM orders WHERE YEAR(order_date) = 2016 AND MONTH(order_date) IN (6, 7)) o
              ON c.customer_id = o.customer_id
         JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id
ORDER BY total_paid desc;


-- 需求18: 统计客户总数和带有传真号码的客户数量
-- 需要字段：all_customers_count 和 customers_with_fax_count
SELECT COUNT(1) as all_customers_count, COUNT(fax) as customers_with_fax_count
FROM customers;


-- 需求19: 我们要在报表中显示每种产品的库存量，但我们不想简单地将“ units_in_stock”列放在报表中。报表中只需要一个总体级别，例如低，高：
-- 库存大于100 的可用性为高(high)
-- 50到100的可用性为中等(moderate)
-- 小于50的为低(low)
-- 零库存 为 (none)
SELECT product_id,
       product_name,
       units_in_stock,
       CASE
           WHEN units_in_stock > 100 THEN '高'
           WHEN units_in_stock = 0 THEN 'none'
           WHEN units_in_stock < 50 THEN '低'
           ELSE '中'
           END AS units_in_stock_level
FROM products;


-- 需求20: 创建一个报表，统计员工的经验水平
-- 显示字段：first_name, last_name, hire_date, 和 experience
-- 经验字段（experience ）：
-- 'junior' 2014年1月1日以后雇用的员工
-- 'middle' 在2013年1月1日之后至2014年1月1日之前雇用的员工
-- 'senior' 2013年1月1日或之前雇用的员工

-- 需求21: 我们的商店要针对北美地区的用户做促销活动：任何运送到北美地区（美国，加拿大) 的包裹免运费。 创建报表，查询订单编号为10720~10730 活动后的运费价格


-- 需求22: 需求：创建客户基本信息报表, 包含字段：客户id customer_id, 公司名字 company_name
-- 所在国家 country, 使用语言language, 使用语言language 的取值按如下规则
-- Germany, Switzerland, and Austria 语言为德语 'German', 	UK, Canada, the USA, and Ireland -- 语言为英语 'English', 其他所有国家 'Other'


-- 需求23: 需求：创建报表将所有产品划分为素食和非素食两类
-- 报表中包含如下字段：产品名字 product_name, 类别名称 category_name
-- 膳食类型 diet_type:
-- 	非素食 'Non-vegetarian' 商品类别字段的值为 'Meat/Poultry' 和 'Seafood'.
-- 	素食

-- 需求24: 在引入北美地区免运费的促销策略时，我们也想知道运送到北美地区和其它国家地区的订单数量
-- 促销策略, 参见需求21的代码.


-- 需求25: 创建报表统计供应商来自那个大洲, 报表中包含两个字段：供应商来自哪个大洲（supplier_continent ）和 供应产品种类数量（product_count）
-- 供应商来自哪个大洲（supplier_continent ）包含如下取值：
-- 'North America' （供应商来自 'USA' 和 'Canada'.）
-- 'Asia' （供应商来自 'Japan' 和 'Singapore')
-- 'Other' (其它国家)


-- 需求26: 需求：创建一个简单的报表来统计员工的年龄情况
-- 报表中包含如下字段
-- 年龄（ age ）：生日大于1980年1月1日 'young' ，其余'old'
--  员工数量 （ employee_count）


-- 需求27: 统计客户的contact_title 字段值为 ’Owner' 的客户数量
-- 查询结果有两个字段：represented_by_owner 和 not_represented_by_owner


-- 需求28: Washington (WA) 是 Northwind的主要运营地区，统计有多少订单是由华盛顿地区的员工处理的，
-- 多少订单是有其它地区的员工处理的
-- 结果字段： orders_wa_employees 和 orders_not_wa_employees


-- 需求29: 创建报表，统计不同类别产品的库存量，将库存量分成两类 >30 和 <=30 两档分别统计数量
-- 报表包含三个字段, 类别名称 category_name, 库存充足 high_availability, 库存紧张 low_availability
-- 简化需求: 统计不同类别产品的库存量


-- 需求30: 创建报表统计运输到法国的的订单中，打折和未打折订单的总数量
-- 结果包含两个字段：full_price （原价）和 discounted_price（打折）
-- select ship_country, discount from orders o, order_items oi where ship_country='France' and o.order_id = oi.order_id;  -- 184


-- 需求31: 输出报表，统计不同供应商供应商品的总库存量，以及高价值商品的库存量（单价超过40定义为高价值）
-- 结果显示四列：
-- 供应商ID supplier_id
-- 供应商公司名 company_name
-- 由该供应商提供的总库存 all_units
-- 由该供应商提供的高价值商品库存 expensive_units

-- 需求32: 创建报表来为每种商品添加价格标签，贵、中等、便宜
-- 结果包含如下字段：product_id, product_name, unit_price, 和 price_level
-- 价格等级price_level的取值说明：
-- 'expensive' 单价高于100的产品
-- 'average' 单价高于40但不超过100的产品
-- 'cheap' 其他产品


-- 需求33: 制作报表统计所有订单的总价（不计任何折扣）对它们进行分类。
-- 包含以下字段：
-- 	order_id
-- 	total_price（折扣前）
-- 	price_group
-- 字段 price_group 取值说明：
-- 	'high' 总价超过2000美元
-- 	'average'，总价在$ 600到$ 2,000之间，包括两端
-- 	'low' 总价低于$ 600


-- 需求34: 统计所有订单的运费，将运费高低分为三档
-- 报表中包含三个字段
-- low_freight freight值小于“ 40.0”的订单数
-- avg_freight freight值大于或等于“ 40.0”但小于“ 80.0”的订单数
-- high_freight freight值大于或等于“ 80.0”的订单数
