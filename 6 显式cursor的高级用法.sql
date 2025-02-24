/*
cursor 的for循环是一种处理显式游标的简洁方式。
隐含地打开、提取、退出和关闭cursor。
记录类型不需要声明，因为已经隐含的声明了和cursor是同一个%rowtype

语法
for 记录名in cursor名 loop
...
...
end loop;

*/
--案例
set serveroutput on 
declare
cursor emp_cursor is select * from emp_pl;
begin
for emp_record in emp_cursor loop -- 1）emp_record隐式的声明了emp_record是一个record类型，并且数据类型和emp_cursor相同 2）隐式的打开了cursor，且提取了数据行
if emp_record.deptno=20 then 
dbms_output.put_line(emp_record.job||' '||emp_record.ename||'在研发部门');
end if ;
end loop;
end;

-- cursor 的 for循环中使用子查询来节省cursor的声明
-- 特点：不用提前声明cursor
-- 缺点是，不能使用cursor的属性，如rowcount

-- 案例
set serveroutput on 
begin
--(select * from emp_pl) 一定要用括号，用子查询来代替预先声明
for  emp_record in(select * from emp_pl) loop -- emp_record记录变量， 4
if emp_record.deptno=20 then 
dbms_output.put_line(emp_record.job||' '||emp_record.ename||'在研发部门');
end if ;
end loop;
end;

-- cursor定义中使用子查询
set serveroutput on 
declare
cursor dept_total_cursor is 
select d.deptno,d.dname,e.max_salary,e.min_salary,e.emp_total,e.avg_salary from dept d,(
select deptno,max(sal)max_salary,round(avg(sal),2)avg_salary,min(sal)min_salary,count(1)emp_total
from emp_pl group by deptno)e
where e.deptno=d.deptno and e.avg_salary>=2000
order by deptno asc; -- cursor 指向一个复杂的select查询语句
-- 开始fetch值
begin
for dept_record in dept_total_cursor loop
dbms_output.put_line(dept_record.deptno||' '||
                    dept_record.dname||'-->'||
                    dept_record.max_salary||' '||
                    dept_record.min_salary||' '||
                    dept_record.emp_total||' '||
                    dept_record.avg_salary);
end loop;
end;

-- 带参数的cursor
-- 好处： 可以提高代码重用性  eg取出来的行做不同的处理

declare
cursor emp_cursor(p_deptno number, p_job varchar2) is  -- 两个参数p_deptno&p_job，其类型分别为number和varchar2
select * from emp_pl where deptno=p_deptno and job=p_job order by empno;
v_emp_record emp_cursor%rowtype;
begin
open emp_cursor(20,'ANALYST');
LOOP
FETCH emp_cursor INTO v_emp_record;
EXIT WHEN emp_cursor%NOTFOUND OR emp_cursor%NOTFOUND IS NULL;
dbms_output.put_line(v_emp_record.empno||' '||
                    v_emp_record.ename||'-->'||
                    v_emp_record.job||' '||
                    v_emp_record.sal||' '||
                    v_emp_record.deptno);
end loop;
close emp_cursor;
-- 第二次调用，并做不同的从处理
for emp_record in emp_cursor(44,'保安') loop
dbms_output.put_line('员工号为'||emp_record.empno||'，职位 '||
                    emp_record.ename||''||
                    emp_record.job||' '||
                    emp_record.sal||' '||
                    emp_record.deptno);
end loop;
end;

