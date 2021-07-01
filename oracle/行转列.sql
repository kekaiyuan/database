-- 行转列
/*
1. 中国移动sql面试题：
create table test(
   id number(10) primary key,
   type number(10) ,
   t_id number(10),
   value varchar2(5)
);
insert into test values(100,1,1,'张三');
insert into test values(200,2,1,'男');
insert into test values(300,3,1,'50');

insert into test values(101,1,2,'刘二');
insert into test values(201,2,2,'男');
insert into test values(301,3,2,'30');

insert into test values(102,1,3,'刘三');
insert into test values(202,2,3,'女');
insert into test values(302,3,3,'10');
请写出一条查询语句结果如下：

姓名      性别     年龄
--------- -------- ----
张三       男        50
*/

select max(decode(type, 1, value)) as 姓名,
       max(decode(type, 2, value)) as 性别,
       max(decode(type, 3, value)) as 年龄
  from test
 group by T_ID;
 
/*
2.一道SQL语句面试题，关于group by
表内容：
2005-05-09 胜
2005-05-09 胜
2005-05-09 负
2005-05-09 负
2005-05-10 胜
2005-05-10 负
2005-05-10 负

如果要生成下列结果, 该如何写sql语句?

          胜 负
2005-05-09 2 2
2005-05-10 1 2
------------------------------------------
create table tmp(rq varchar2(10),shengfu varchar2(5));

insert into tmp values('2005-05-09','胜');
insert into tmp values('2005-05-09','胜');
insert into tmp values('2005-05-09','负');
insert into tmp values('2005-05-09','负');
insert into tmp values('2005-05-10','胜');
insert into tmp values('2005-05-10','负');
insert into tmp values('2005-05-10','负');
*/

select * from tmp;

select rq,
       sum(decode(shengfu, '胜', 1)) as "胜",
       sum(decode(shengfu, '负', 1)) as "负"
  from tmp
 group by rq
 order by rq;
 
select rq,
       decode(shengfu, '胜', 1) as "胜",
       decode(shengfu, '负', 1) as "负"
  from tmp;
 
/*
4.create table STUDENT_SCORE
(
  name    VARCHAR2(20),
  subject VARCHAR2(20),
  score   NUMBER(4,1)
);
insert into student_score (NAME, SUBJECT, SCORE) values ('张三', '语文', 78.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('张三', '数学', 88.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('张三', '英语', 98.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('李四', '语文', 89.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('李四', '数学', 76.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('李四', '英语', 90.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('王五', '语文', 99.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('王五', '数学', 66.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('王五', '英语', 91.0);

4.1得到类似下面的结果
姓名   语文  数学  英语

王五    89    56    89
*/
-- 使用四种方式写出
-- decode
select name,
       max(decode(subject, '语文', score)) as 语文,
       max(decode(subject, '数学', score)) as 数学,
       max(decode(subject, '英语', score)) as 英语
  from student_score group by name;
-- case when
select name,
       max(case subject
             when '语文' then
              score
           end) 语文,
       max(case subject
             when '数学' then
              score
           end) 数学,
       max(case subject
             when '英语' then
              score
           end) 英语
  from student_score
 group by name;
-- join
select ss1.name, ss1.score 语文, ss2.score 数学, ss3.score 英语
  from (select name, score from student_score where subject = '语文') ss1
  join (select name, score from student_score where subject = '数学') ss2
    on ss1.name = ss2.name
  join (select name, score from student_score where subject = '英语') ss3
    on ss1.name = ss3.name;
-- union all
create view v_ss as 
  select name, score 语文, 0 数学, 0 英语
    from student_score
   where subject = '语文'
  union all
  select name, 0 语文, score 数学, 0 英语
    from student_score
   where subject = '数学'
  union all
  select name, 0 语文, 0 数学, score 英语
    from student_score
   where subject = '英语';
         
select name, sum(语文) 语文, sum(数学) 数学, sum(英语) 英语
  from v_ss
 group by name;

/*4.2有一张表，里面有3个字段：语文，数学，英语。
其中有3条记录分别表示语文70分，数学80分，英语58分，
请用一条sql语句查询出这三条记录并按以下条件显示出来（并写出您的思路）：  
   大于或等于80表示优秀，大于或等于60表示及格，小于60分表示不及格。  
       显示格式：  
       语文              数学                英语  
       及格              优秀                不及格    
------------------------------------------
*/

create view v_ss02 as
  select name,
         subject,
         case
           when score >= 80 then
            '优秀'
           when score >= 60 then
            '及格'
           else
            '不及格'
         end as 等级
    from student_score;
          
select name,
       max(decode(subject, '语文', 等级)) 语文,
       max(decode(subject, '数学', 等级)) 数学,
       max(decode(subject, '英语', 等级)) 英语
  from v_ss02
 group by name;
 
/*
5.请用一个sql语句得出结果
从table1,table2中取出如table3所列格式数据，注意提供的数据及结果不准确，
只是作为一个格式向大家请教。

table1

月份mon 部门dep 业绩yj
-------------------------------
一月份      01      10
一月份      02      10
二月份      03      5
二月份      02      8
三月份      04      9
三月份      03      8

table2

部门dep      部门名称dname
--------------------------------
      01      国内业务一部
      02      国内业务二部
      03      国内业务三部
      04      国际业务部

table3 （result）

部门                       一月份        二月份        三月份
-------------------- ---------- ---------- ----------
国内业务一部                10          0          0
国内业务二部                10          8          0
国内业务三部                 0           5          8
国际业务部                    0           0          9

create table yj01(
       month varchar2(10),
       deptno number(10),
       yj number(10)
)

insert into yj01(month,deptno,yj) values('一月份',01,10);
insert into yj01(month,deptno,yj) values('一月份',02,10);
insert into yj01(month,deptno,yj) values('二月份',03,5);
insert into yj01(month,deptno,yj) values('二月份',02,8);
insert into yj01(month,deptno,yj) values('三月份',04,9);
insert into yj01(month,deptno,yj) values('三月份',03,8);

create table yjdept(
       deptno number(10),
       dname varchar2(20)
)

insert into yjdept(deptno,dname) values(01,'国内业务一部');
insert into yjdept(deptno,dname) values(02,'国内业务二部');
insert into yjdept(deptno,dname) values(03,'国内业务三部');
insert into yjdept(deptno,dname) values(04,'国际业务部');
*/

create view v_yj01 as
  select deptno,
         sum(decode(month, '一月份', yj)) Jan,
         sum(decode(month, '二月份', yj)) Feb,
         sum(decode(month, '三月份', yj)) Mar
    from yj01
   group by deptno;

select dname 部门, nvl(Jan, 0) 一月份, nvl(Feb, 0) 二月份, nvl(Mar, 0) 三月份
  from v_yj01, yjdept
 where v_yj01.deptno = yjdept.deptno
 order by yjdept.deptno;
