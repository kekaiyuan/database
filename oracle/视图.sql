-- ��ƽ��нˮ�ĵȼ���͵Ĳ��ŵĲ���������ʲô������ȫʹ���Ӳ�ѯ
-- 1. ��ƽ��нˮ
select deptno, avg(sal) from emp group by deptno;
-- 2. ��ƽ��нˮ�ĵȼ�
select e.deptno, sg.grade
  from (select deptno, avg(sal) avg_sal from emp group by deptno) e
  join salgrade sg
    on e.avg_sal between sg.losal and sg.hisal ;
-- 3. ��ƽ��нˮ�ĵȼ���͵Ĳ���
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
 
-- 4. ��ƽ��нˮ�ĵȼ���͵Ĳ�������
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
�鿴sql����ܹ����֣�sql���кܶ���ظ���sql�Ӳ�ѯ
����ͨ����ͼ���ظ��������������
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
