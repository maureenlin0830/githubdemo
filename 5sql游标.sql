-- 游标cursor
/*
定义：
当PL/SQL程序的执行发出一个sql语句时，ORACLE服务器为处理的sql语句会分配一个称为上下文（环境）区域的私有内存区，
同时，PL/SQL会创建一个隐式cursor*/
-- 隐式游标的属性
/*
SQL%FOUND 如果刚执行过的sql语句至少返回一行数据，那么结果为TRUE
SQL%NOTFOUND
SQL%ROWCOUNT 返回sql执行语句影响的行数
当select语句没有提取到任何数据行，pl/SQL会返回异常,
前缀加SQL，因为隐式cursor没有名称
*/
-- 1.隐式cursor属性的用法

set verify off 
set serveroutput on 
declare
v_row_updated varchar(38);
v_deptno emp_pl.deptno%type:=&p_dept;
begin
update emp_pl
set sal=9999
where deptno=v_deptno;
v_row_updated:=(sql%rowcount||'行被执行了');
dbms_output.put_line(v_row_updated);
end;
-- 2.显式cursor
/*oracle会为所有的DML语句和PL/SQL的select语句分配一个私有的sql区，当返回多行数据时，可以使用显式cursor来命名一个私有的sql区
一个多行查询所返回的数据行的集合，称之为活动集*/
--显式cursor使用步骤
/*
1.声明显式cursor  -- 给cursor一个名字
2.打开显式游标 open cursor -- 打开内存盒子
3.从定义的cursor里fetch数据，每次fetch之后需要测试数据集里是否还有数据
4.关闭显式cursor

CURSOR cursor_name is 
select _statement; -- 为一个没有into子句的select语句
*/
-- 案例 声明cursor
--declare
---- 要先声明变量，数量与cursor相同，便于fetch后存入相应变量中
--v_empno emp.empno%type;
--v_ename emp.ename%type;
--v_job emp.job%type;
--v_sal emp.sal%type;
--CURSOR emp_cursor is 
--select empno,ename,job,sal from emp where deptno=20 order by sal; --cursor存放了dept=20的活动集，当open时，会指向该活动集的第一行
-- 案例 打开cursor并提取数据
set verify off 
set serveroutput on 
declare
v_empno emp.empno%type;
v_ename emp.ename%type;
v_job emp.job%type;
v_sal emp.sal%type;
CURSOR emp_cursor is 
select empno,ename,job,sal from emp where empno=7900;
begin
open emp_cursor;
fetch emp_cursor into v_empno,v_ename,v_job,v_sal;-- fetch语句的into子句中包含的变量个数要与cursor中select语句中的列数相同 
dbms_output.put_line(v_empno||' '||v_ename||' '||v_job||' '||v_sal);
close emp_cursor;
end;
-- 2.1显式游标的属性
/*
%ISOPEN
%FOUND 如果刚执行过的sql语句至少返回一行数据，那么结果为TRUE
%NOTFOUND
%ROWCOUNT 返回sql执行语句影响的行数
*/
    /*属性 举例
    -- 只有当cursor打开时，才能fetch数据行，所以在fetch语句执行前，最好加上%isopen属性，以确定cursor是打开的。
    if not sales_cursor%isopen then
    open sales_cursor;
    end if;
    loop
    fetch sales_cursor...
    -- 设置循环退出条件。    
    loop
    fetch emp_cursor into  v_name,v_sal,v_hiredate;
    exit when emp_cursor%notfound or emp_cursor%notfound is null  如果fetch语句从来没成功过，那么值为null;
    end loop;
    -- %ROWCOUNT使用
    loop
    fetch emp_cursor into  v_name,v_sal,v_hiredate;
    if emp_cursor%ROWCOUNT>10 then 
    ...
    end if ;
    end loop; 
    */
    
-- 3.利用循环控制cursor的实例
set SERVEROUTPUT on 
declare
v_empno emp_pl.empno%type;
v_ename emp_pl.ename%type;
v_job emp_pl.job%type;
v_sal emp_pl.sal%type;
cursor emp_cursor IS
select empno,ename,job,sal from emp_pl order by sal; -- 定义cursor 

begin 
open emp_cursor;
loop
fetch emp_cursor into v_empno,v_ename,v_job,v_sal;
exit when emp_cursor%ROWCOUNT>8 or emp_cursor%notfound or emp_cursor%notfound is null;
dbms_output.put_line(v_empno||' '||v_ename||' '||v_job||' '||v_sal);
end loop;
close emp_cursor;
end;

-- 4.cursor与记录      
set serveroutput on 
declare 
cursor emp_cursor is select * from emp_pl; -- 声明一个cursor
emp_record emp_cursor%rowtype; -- 定义一个记录类型

type emp_table_type is table of emp_pl%rowtype index by pls_integer;--PL/SQL集合声明
v_emp_table emp_table_type; -- PL/SQL集合实例化
n number :=1;

begin
open emp_cursor;
loop
fetch emp_cursor into emp_record; 
exit when emp_cursor%notfound or emp_cursor%notfound is null;
-- emp_record只能存放一条记录，所以要通过emp_table的索引把每条记录保存下来
v_emp_table(n):=emp_record;
n:=n+1;
end loop;
CLOSE emp_cursor; -- 关闭cursor

<<outer_loop>>
for i in v_emp_table.first..v_emp_table.last loop
    for j in v_emp_table.first..v_emp_table.last loop
    if v_emp_table(i).empno=v_emp_table(j).mgr
    then 
    dbms_output.put_line(v_emp_table(i).job||' '||v_emp_table(i).ename||'是经理岗位，且不是光杆司令');
    continue outer_loop;-- 带标签，所以跳过了外层循环的当前迭代，直接进入下一次外层循环的迭代
    end if;
    end loop;
    end loop outer_loop;
    end;
    
