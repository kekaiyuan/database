-- ��ת��
/*
1. �й��ƶ�sql�����⣺
create table test(
   id number(10) primary key,
   type number(10) ,
   t_id number(10),
   value varchar2(5)
);
insert into test values(100,1,1,'����');
insert into test values(200,2,1,'��');
insert into test values(300,3,1,'50');

insert into test values(101,1,2,'����');
insert into test values(201,2,2,'��');
insert into test values(301,3,2,'30');

insert into test values(102,1,3,'����');
insert into test values(202,2,3,'Ů');
insert into test values(302,3,3,'10');
��д��һ����ѯ��������£�

����      �Ա�     ����
--------- -------- ----
����       ��        50
*/

select max(decode(type, 1, value)) as ����,
       max(decode(type, 2, value)) as �Ա�,
       max(decode(type, 3, value)) as ����
  from test
 group by T_ID;
 
/*
2.һ��SQL��������⣬����group by
�����ݣ�
2005-05-09 ʤ
2005-05-09 ʤ
2005-05-09 ��
2005-05-09 ��
2005-05-10 ʤ
2005-05-10 ��
2005-05-10 ��

���Ҫ�������н��, �����дsql���?

          ʤ ��
2005-05-09 2 2
2005-05-10 1 2
------------------------------------------
create table tmp(rq varchar2(10),shengfu varchar2(5));

insert into tmp values('2005-05-09','ʤ');
insert into tmp values('2005-05-09','ʤ');
insert into tmp values('2005-05-09','��');
insert into tmp values('2005-05-09','��');
insert into tmp values('2005-05-10','ʤ');
insert into tmp values('2005-05-10','��');
insert into tmp values('2005-05-10','��');
*/

select * from tmp;

select rq,
       sum(decode(shengfu, 'ʤ', 1)) as "ʤ",
       sum(decode(shengfu, '��', 1)) as "��"
  from tmp
 group by rq
 order by rq;
 
select rq,
       decode(shengfu, 'ʤ', 1) as "ʤ",
       decode(shengfu, '��', 1) as "��"
  from tmp;
 
/*
4.create table STUDENT_SCORE
(
  name    VARCHAR2(20),
  subject VARCHAR2(20),
  score   NUMBER(4,1)
);
insert into student_score (NAME, SUBJECT, SCORE) values ('����', '����', 78.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('����', '��ѧ', 88.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('����', 'Ӣ��', 98.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('����', '����', 89.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('����', '��ѧ', 76.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('����', 'Ӣ��', 90.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('����', '����', 99.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('����', '��ѧ', 66.0);
insert into student_score (NAME, SUBJECT, SCORE) values ('����', 'Ӣ��', 91.0);

4.1�õ���������Ľ��
����   ����  ��ѧ  Ӣ��

����    89    56    89
*/
-- ʹ�����ַ�ʽд��
-- decode
select name,
       max(decode(subject, '����', score)) as ����,
       max(decode(subject, '��ѧ', score)) as ��ѧ,
       max(decode(subject, 'Ӣ��', score)) as Ӣ��
  from student_score group by name;
-- case when
select name,
       max(case subject
             when '����' then
              score
           end) ����,
       max(case subject
             when '��ѧ' then
              score
           end) ��ѧ,
       max(case subject
             when 'Ӣ��' then
              score
           end) Ӣ��
  from student_score
 group by name;
-- join
select ss1.name, ss1.score ����, ss2.score ��ѧ, ss3.score Ӣ��
  from (select name, score from student_score where subject = '����') ss1
  join (select name, score from student_score where subject = '��ѧ') ss2
    on ss1.name = ss2.name
  join (select name, score from student_score where subject = 'Ӣ��') ss3
    on ss1.name = ss3.name;
-- union all
create view v_ss as 
  select name, score ����, 0 ��ѧ, 0 Ӣ��
    from student_score
   where subject = '����'
  union all
  select name, 0 ����, score ��ѧ, 0 Ӣ��
    from student_score
   where subject = '��ѧ'
  union all
  select name, 0 ����, 0 ��ѧ, score Ӣ��
    from student_score
   where subject = 'Ӣ��';
         
select name, sum(����) ����, sum(��ѧ) ��ѧ, sum(Ӣ��) Ӣ��
  from v_ss
 group by name;

/*4.2��һ�ű�������3���ֶΣ����ģ���ѧ��Ӣ�
������3����¼�ֱ��ʾ����70�֣���ѧ80�֣�Ӣ��58�֣�
����һ��sql����ѯ����������¼��������������ʾ��������д������˼·����  
   ���ڻ����80��ʾ���㣬���ڻ����60��ʾ����С��60�ֱ�ʾ������  
       ��ʾ��ʽ��  
       ����              ��ѧ                Ӣ��  
       ����              ����                ������    
------------------------------------------
*/

create view v_ss02 as
  select name,
         subject,
         case
           when score >= 80 then
            '����'
           when score >= 60 then
            '����'
           else
            '������'
         end as �ȼ�
    from student_score;
          
select name,
       max(decode(subject, '����', �ȼ�)) ����,
       max(decode(subject, '��ѧ', �ȼ�)) ��ѧ,
       max(decode(subject, 'Ӣ��', �ȼ�)) Ӣ��
  from v_ss02
 group by name;
 
/*
5.����һ��sql���ó����
��table1,table2��ȡ����table3���и�ʽ���ݣ�ע���ṩ�����ݼ������׼ȷ��
ֻ����Ϊһ����ʽ������̡�

table1

�·�mon ����dep ҵ��yj
-------------------------------
һ�·�      01      10
һ�·�      02      10
���·�      03      5
���·�      02      8
���·�      04      9
���·�      03      8

table2

����dep      ��������dname
--------------------------------
      01      ����ҵ��һ��
      02      ����ҵ�����
      03      ����ҵ������
      04      ����ҵ��

table3 ��result��

����                       һ�·�        ���·�        ���·�
-------------------- ---------- ---------- ----------
����ҵ��һ��                10          0          0
����ҵ�����                10          8          0
����ҵ������                 0           5          8
����ҵ��                    0           0          9

create table yj01(
       month varchar2(10),
       deptno number(10),
       yj number(10)
)

insert into yj01(month,deptno,yj) values('һ�·�',01,10);
insert into yj01(month,deptno,yj) values('һ�·�',02,10);
insert into yj01(month,deptno,yj) values('���·�',03,5);
insert into yj01(month,deptno,yj) values('���·�',02,8);
insert into yj01(month,deptno,yj) values('���·�',04,9);
insert into yj01(month,deptno,yj) values('���·�',03,8);

create table yjdept(
       deptno number(10),
       dname varchar2(20)
)

insert into yjdept(deptno,dname) values(01,'����ҵ��һ��');
insert into yjdept(deptno,dname) values(02,'����ҵ�����');
insert into yjdept(deptno,dname) values(03,'����ҵ������');
insert into yjdept(deptno,dname) values(04,'����ҵ��');
*/

create view v_yj01 as
  select deptno,
         sum(decode(month, 'һ�·�', yj)) Jan,
         sum(decode(month, '���·�', yj)) Feb,
         sum(decode(month, '���·�', yj)) Mar
    from yj01
   group by deptno;

select dname ����, nvl(Jan, 0) һ�·�, nvl(Feb, 0) ���·�, nvl(Mar, 0) ���·�
  from v_yj01, yjdept
 where v_yj01.deptno = yjdept.deptno
 order by yjdept.deptno;
