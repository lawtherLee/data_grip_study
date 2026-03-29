SHOW DATABASES;

CREATE DATABASE IF NOT EXISTS school;

# 学生表 Student
CREATE TABLE student
(
    SId   varchar(10),
    Sname varchar(10),
    Sage  datetime,
    Ssex  varchar(10)
);
# 科目表 Course
CREATE TABLE course
(
    CId   VARCHAR(10),
    Cname NVARCHAR(10),
    TId   VARCHAR(10)
);
# 教师表 Teacher
CREATE TABLE teacher
(
    TId   VARCHAR(10),
    Tname VARCHAR(10)
);
# 成绩表 SC
CREATE TABLE sc
(
    SId   VARCHAR(10),
    CId   VARCHAR(10),
    score DECIMAL(18, 1)
);
# insert into Student
# values ('01', '赵雷', '1990-01-01', '男');
# insert into Student
# values ('02', '钱电', '1990-12-21', '男');
# insert into Student
# values ('03', '孙风', '1990-12-20', '男');
# insert into Student
# values ('04', '李云', '1990-12-06', '男');
# insert into Student
# values ('05', '周梅', '1991-12-01', '女');
# insert into Student
# values ('06', '吴兰', '1992-01-01', '女');
# insert into Student
# values ('07', '郑竹', '1989-01-01', '女');
# insert into Student
# values ('09', '张三', '2017-12-20', '女');
# insert into Student
# values ('10', '李四', '2017-12-25', '女');
# insert into Student
# values ('11', '李四', '2012-06-06', '女');
# insert into Student
# values ('12', '赵六', '2013-06-13', '女');
# insert into Student
# values ('13', '孙七', '2014-06-01', '女');
# insert into Course
# values ('01', '语文', '02');
# insert into Course
# values ('02', '数学', '01');
# insert into Course
# values ('03', '英语', '03');
# insert into Teacher
# values ('01', '张三');
# insert into Teacher
# values ('02', '李四');
# insert into Teacher
# values ('03', '王五');
# insert into SC
# values ('01', '01', 80);
# insert into SC
# values ('01', '02', 90);
# insert into SC
# values ('01', '03', 99);
# insert into SC
# values ('02', '01', 70);
# insert into SC
# values ('02', '02', 60);
# insert into SC
# values ('02', '03', 80);
# insert into SC
# values ('03', '01', 80);
# insert into SC
# values ('03', '02', 80);
# insert into SC
# values ('03', '03', 80);
# insert into SC
# values ('04', '01', 50);
# insert into SC
# values ('04', '02', 30);
# insert into SC
# values ('04', '03', 20);
# insert into SC
# values ('05', '01', 76);
# insert into SC
# values ('05', '02', 87);
# insert into SC
# values ('06', '01', 31);
# insert into SC
# values ('06', '03', 34);
# insert into SC
# values ('07', '02', 89);
# insert into SC
# values ('07', '03', 98);

# 1. 查询 "01" 课程比 "02" 课程成绩高的学生的信息及课程分数
# 1.1 同时存在 "01" 和 "02" 课程的情况
SELECT s.*, sc1.score AS c01_score, sc2.score AS c02_score
FROM Student s
         JOIN SC sc1 ON s.SId = sc1.SId AND sc1.CId = '01'
         JOIN SC sc2 ON s.SId = sc2.SId AND sc2.CId = '02'
WHERE sc1.score > sc2.score;
# 1.2 存在 "01" 课程，可能不存在 "02" 课程（不存在显示 null）
SELECT s.*, sc2.score AS c02_score
FROM Student s
         JOIN SC sc2 ON s.SId = sc2.SId AND sc2.CId = '02'
         LEFT JOIN SC sc1 ON s.SId = sc1.SId AND sc1.CId = '01'
WHERE sc1.SId IS NULL;
# 1.3 不存在 "01" 课程，存在 "02" 课程的情况
SELECT s.*, sc2.score AS c02_score
FROM Student s
         JOIN SC sc2 ON s.SId = sc2.SId AND sc2.CId = '01'
         LEFT JOIN SC sc1 ON s.SId = sc1.SId AND sc1.CId = '02'
WHERE sc1.SId IS NULL;

# 2. 查询平均成绩大于等于 60 分的同学的学生编号、姓名和平均成绩
SELECT s.SId, s.Sname, ROUND(AVG(sc.score), 1) AS avg_score
FROM student s
         JOIN sc ON s.SId = sc.SId
GROUP BY s.SId, s.Sname
HAVING AVG(sc.score) >= 60;

# 3. 查询在 SC 表存在成绩的学生信息
SELECT DISTINCT S.*
FROM student s
         JOIN sc ON s.SId = sc.SId;

# 4. 查询所有同学的学生编号、姓名、选课总数、所有课程的成绩总和
# 4.1 显示没选课的学生（选课数 / 总分显示 NULL）
SELECT s.SId,
       s.Sname,
       COUNT(CId) AS course_num,
       SUM(score) AS total_score
FROM student s
         LEFT JOIN sc ON s.SId = sc.SId
GROUP BY s.SId, s.Sname;
# 4.2 只查有成绩的学生信息
SELECT s.SId, s.Sname, COUNT(sc.CId) AS course_num, SUM(score) AS total_score
FROM student s
         JOIN sc ON s.SId = sc.SId
GROUP BY s.SId, s.Sname;

# 5. 查询「李」姓老师的数量
SELECT COUNT(*) AS 李老师数量
FROM teacher
WHERE Tname LIKE '李%';

# 6. 查询学过「张三」老师授课的同学的信息
SELECT *
FROM student s
         JOIN sc ON s.SId = sc.SId
         JOIN course c ON sc.CId = c.CId
         JOIN teacher t ON c.TId = t.TId
WHERE t.Tname = '张三';

# 7. 查询没有学全所有课程的同学的信息
SELECT s.*
FROM student s
         LEFT JOIN sc ON s.SId = sc.SId
GROUP BY s.SId, s.Sname, s.Sage, s.Ssex
HAVING COUNT(sc.CId) < (SELECT COUNT(*) FROM course);

# 8. 查询至少有一门课与学号为 "01" 的同学所学相同的同学的信息
SELECT s.*
FROM student s
         JOIN sc ON s.SId = sc.SId
WHERE sc.CId IN (SELECT CId FROM sc WHERE sc.CId = '01')
  AND s.SId != '01';

# 9. 查询和 "01" 号同学学习的课程完全相同的其他同学的信息
SELECT s.*
FROM student s
WHERE SId != '01'
  AND (SELECT GROUP_CONCAT(CId ORDER BY CId) FROM sc WHERE sc.SId = s.SId) =
      (SELECT GROUP_CONCAT(CId ORDER BY CId) FROM sc WHERE sc.SId = '01');

# 10. 查询没学过 "张三" 老师讲授的任一门课程的学生姓名
SELECT Sname
FROM student s
WHERE NOT EXISTS(SELECT 1
                 FROM sc
                          JOIN course c ON sc.CId = c.CId
                          JOIN teacher t ON c.TId = t.TId
                 WHERE sc.SId = s.SId
                   AND t.Tname = '张三');

# 11. 查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩


# 30. 查询存在不及格的课程
SELECT DISTINCT c.CId, c.Cname
FROM Course c
         JOIN SC sc ON c.CId = sc.CId
WHERE sc.score < 60;

# 31. 查询课程编号为 01 且课程成绩在 80 分及以上的学生的学号和姓名
SELECT s.SId, s.Sname
FROM Student s
         JOIN SC sc ON s.SId = sc.SId
WHERE sc.CId = '01'
  AND sc.score >= 80;

# 32. 求每门课程的学生人数
SELECT c.CId, c.Cname, COUNT(sc.SId) AS 学生人数
FROM Course c
         LEFT JOIN SC sc ON c.CId = sc.CId
GROUP BY c.CId, c.Cname;

# 33. 成绩不重复，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
SELECT s.*, sc.score, c.Cname
FROM Student s
         JOIN SC sc ON s.SId = sc.SId
         JOIN Course c ON sc.CId = c.CId
         JOIN Teacher t ON c.TId = t.TId
WHERE t.Tname = '张三'
ORDER BY sc.score DESC
LIMIT 1;

# 34. 成绩有重复的情况下，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
SELECT *
FROM (SELECT s.*, sc.score, c.Cname, DENSE_RANK() OVER (PARTITION BY sc.CId ORDER BY sc.score DESC ) AS 排名
      FROM student s
               JOIN sc ON s.SId = sc.SId
               JOIN course c ON sc.CId = c.CId
               JOIN teacher t ON c.TId = t.TId
      WHERE t.Tname = '张三') t
WHERE t.排名 = 1;

# 35. 查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩
SELECT DISTINCT sc1.SId, sc1.CId, sc1.score
FROM sc sc1
         JOIN sc sc2 ON sc1.SId = sc2.SId AND sc1.CId != sc2.CId AND sc1.score = sc2.score;

# 36. 查询每门功课成绩最好的前两名
SELECT *
FROM (SELECT CId, SId, score, ROW_NUMBER() OVER (PARTITION BY CId ORDER BY score DESC ) AS 排名 FROM sc) t
WHERE t.排名 <= 2;

# 37. 统计每门课程的学生选修人数（超过 5 人的课程才统计）
SELECT CId, COUNT(SId) AS 选修人数
FROM sc
GROUP BY CId
HAVING COUNT(SId) > 5;

# 38. 检索至少选修两门课程的学生学号
SELECT SId
FROM sc
GROUP BY SId
HAVING COUNT(CId) >= 2;


# 39. 查询选修了全部课程的学生信息
SELECT *
FROM Student s
WHERE s.SId IN (
    -- 子查询：只找出【选了全部课的学生ID】
    SELECT SId
    FROM SC
    GROUP BY SId
    HAVING COUNT(CId) = (SELECT COUNT(*) FROM Course));


# 40. 查询各学生的年龄，只按年份来算
SELECT SId, Sname, YEAR(NOW()) - YEAR(Sage) AS 年龄
FROM student;

# 41. 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一
SELECT SId,
       Sname,
       IF(DATE_FORMAT(NOW(), '%m%d') < DATE_FORMAT(Sage, '%m%d'),
          YEAR(NOW()) - YEAR(Sage) - 1,
          YEAR(NOW()) - YEAR(Sage)) AS 实际年龄
FROM student;

# 42. 查询本周过生日的学生
SELECT *
FROM student
WHERE WEEKOFYEAR(Sage) = WEEKOFYEAR(NOW())
  AND YEAR(Sage) != YEAR(NOW());

# 43. 查询下周过生日的学生
SELECT *
FROM student
WHERE WEEKOFYEAR(Sage) = WEEKOFYEAR(NOW()) + 1
  AND YEAR(Sage) != YEAR(NOW());

# 44. 查询本月过生日的学生
SELECT *
FROM student
WHERE MONTH(Sage) = MONTH(NOW());

# 45. 查询下月过生日的学生（12 月则下月为 1 月）
SELECT *
FROM student
WHERE MONTH(Sage) = IF(MONTH(NOW()) = 12, 1, MONTH(NOW()) + 1);
