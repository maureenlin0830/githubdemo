-- 创建序列
create SEQUENCE DEPTID_SEQUENCE 
START WITH 50 
INCREMENT BY 5
MAXVALUE 99
NOCACHE
NOCYCLE;
--#查看序列信息
select * from user_sequences;

select * from dept;
begin
insert into dept(deptno,dname,loc)
values
(deptid_sequence.nextval,'公关部','公主坟区');
end;
--sql的update语句
create table  emp_pl as select * from emp;
select * from emp_pl where job='CLERK';
--&代表这是一个输入变量，
set verify off 
declare v_sal_increase emp_pl.sal%type :=&p_salary_increase;
begin
update emp_pl
set sal=sal+v_sal_increase
where job='CLERK';
commit;
end;
--需求:删除salesman里面工资大于1300的
set verify off
declare v_sal emp_pl.sal%type :=&p_salary;
 -- 这样就不需要在输入时，增加单引号，否则字符型要加引号
        v_job emp_pl.job%type :='&p_job';
        begin
        Delete from emp_pl where job=v_job and sal>v_sal;
        end;
select * from emp_pl where job='SALESMAN';
--需求:merge的使用
create table  emp_copy as select * from emp where deptno=20;
select * from emp_copy;

begin
merge into emp_copy c
        using emp b
on (c.empno=b.empno)
when matched then 
update set
c.job=b.job,
c.ename=b.ename,
c.sal=b.sal
when not matched then 
insert values(b.empno,b.ename,b.job,b.mgr,b.hiredate,b.sal,b.comm,b.deptno);
end;
commit;

