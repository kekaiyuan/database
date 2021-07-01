-- 求平均薪水的等级最低的部门的部门名称是什么，先完全使用子查询
-- 1. 求平均薪水
select deptno, avg(sal) from emp group by deptno;
-- 2. 求平均薪水的等级
select e.deptno, sg.grade
  from (select deptno, avg(sal) avg_sal from emp group by deptno) e
  join salgrade sg
    on e.avg_sal between sg.losal and sg.hisal ;
-- 3. 求平均薪水的等级最低的部门
select deptno
  from (select e.deptno, sg.grade gd
          from (select deptno, avg(sal) avg_sal from emp group by deptno) e
          join salgrade sg
            on e.avg_sal between sg.losal and sg.hisal) t
 where t.gd =
       (select min(sg.grade)
          from (select deptno, avg(sal) avg_sal from emp group by deptno) e
          join salgrade sg
            on e.avg_sal between sg.losal and sg.hisal);
 
-- 4. 求平均薪水的等级最低的部门名称
select dname
  from (select deptno
          from (select e.deptno, sg.grade gd
                  from (select deptno, avg(sal) avg_sal
                          from emp
                         group by deptno) e
                  join salgrade sg
                    on e.avg_sal between sg.losal and sg.hisal) t
         where t.gd =
               (select min(sg.grade)
                  from (select deptno, avg(sal) avg_sal
                          from emp
                         group by deptno) e
                  join salgrade sg
                    on e.avg_sal between sg.losal and sg.hisal)) d
  join dept
    on d.deptno = dept.deptno;
    
/*
查看sql语句能够发现，sql中有很多的重复的sql子查询
可以通过视图将重复的语句给抽象出来
*/

create view v_deptno_grade as
  select e.deptno , sg.grade
    from (select deptno, avg(sal) avg_sal from emp group by deptno) e
    join salgrade sg
      on e.avg_sal between sg.losal and sg.hisal;

select dname
  from dept d
  join v_deptno_grade v
    on d.deptno = v.deptno
 where v.grade = (select min(grade) from v_deptno_grade);
