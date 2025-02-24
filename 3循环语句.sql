-- 循环语句
-- 基本循环loop，执行无条件的重复操作； 粗腰的hi用一个人exit来终止循环
-- 需求 循环输入4个保安，工资是1738，部门44
set verify off
SET SERVEROUTPUT ON
declare
v_empno emp_pl.empno%type;
v_job       emp_pl.job%type:='&p_job';
v_SAL       emp_pl.SAL%type:=&SAL;
v_DEPTNO    emp_pl.DEPTNO%type:=&DEPTNO;
v_counter number :=1;
v_hiredate date :=sysdate;
v_max_number number:=&p_number;
begin
select max(empno)into v_empno from emp_pl;
loop
insert into emp_pl(empno,JOB,HIREDATE,SAL,DEPTNO)
values ((v_empno+v_counter),v_job,v_hiredate,v_SAL,v_DEPTNO);
v_counter:=v_counter+1;
dbms_output.put_line(v_counter);
exit when v_counter > v_max_number; -- exit when  表明了循环结束的条件
end loop;
end;

select * from dept_pl;
--while loop 循环
--需求 循环输入3个部门
set verify off
SET SERVEROUTPUT ON
declare
v_counter number:=1;
v_deptno dept_pl.deptno%type;
v_loc dept_pl.loc%type:='&p_loc';
v_number number :=&p_num;
begin
while v_counter <=v_number loop
insert into dept_pl(deptno,loc)values
((deptid_sequence.nextval),v_loc);
v_counter:=v_counter+1;
end loop;
end;
-- for循环
--for counter [Reverse]
--in [a,b] 闭区间 
--loop   end loop
-- 写法 for i in a..b
set verify off
SET SERVEROUTPUT ON
declare

--v_deptno dept_pl.deptno%type;
v_loc dept_pl.loc%type:='&p_loc';
v_number number :=&p_num;
begin
for i in 1..v_number
loop
insert into dept_pl(deptno,loc)values
((deptid_sequence.nextval),v_loc);
end loop;
end;

-- for循环倒序

set serveroutput on
set verify off
declare
v_empno emp_pl.empno%type;
v_job       emp_pl.job%type:='&p_job';
v_SAL       emp_pl.SAL%type:=&SAL;
v_DEPTNO    emp_pl.DEPTNO%type:=&DEPTNO;
v_hiredate date :=sysdate;
v_max_number number:=&p_number;
begin
select max(empno)into v_empno from emp_pl;
for i in reverse 1..v_max_number loop
insert into emp_pl(empno,JOB,HIREDATE,SAL,DEPTNO)
values ((v_empno+i),v_job,v_hiredate,v_SAL,v_DEPTNO);
end loop;
end;


-- 循环嵌套
-- 可以使用《》来表示内循环、外循环
declare 
v_total number :=0;
v_factorial number:=1;
v_num number := &p_num;
begin
<<outer_loop>> -- 外循环名称
for i in 1..v_num loop
v_total:=v_total+i; -- 累计和
dbms_output.put_line('1~'||i||'自然数的总和:'||v_total);
<<inner_loop>>
for j in 1..v_num LOOP
exit inner_loop when i+j>4; -- 这里也可以写外循环的退出条件 如exit outer_loop when i+j>4;
v_factorial:=v_factorial*j;
dbms_output.put_line('自然数'||j||'的阶乘是:'||v_factorial);
end loop ; 
v_factorial:=1; 
end loop outer_loop;-- 结束内循环，可以在end loop后面标明
end;
-- 当输入10时，内循环值会执行到i=3，后面不会执行内循环，因为i+j>4条件满足，直接退出内循环

-- continue
<<inner_loop>>
for j in 1..v_num LOOP
continue outer_loop when i+j>4; -- 看到continue，当满足条件时，，程序性能会跳转到外循环的开始位置
v_factorial:=v_factorial*j;

