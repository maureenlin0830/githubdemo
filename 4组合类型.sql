-- 组合数据类型
--1.PL/SQL记录 
--1.1语法
--type 数据类型名 is record （ type & is record 是关键字)
--例子
    --declare 
    --type emp_record_type is record
    --(empno number not null :=&p_empno,
    --ename emp.ename%type,
    --job emp.job%type,
    --sal emp.sal%type,
    --hiredate emp.hiredate%type) -- 这里记录的是记录类型内部元素
    --emp_record emp_record_type -- 这里emp_record就是记录变量，直接引用记录类型
-- 案例
set verify off
set serveroutput on 
declare 
type emp_record_type is record
(empno number not null :=&p_empno,
ename emp.ename%type,
job emp.job%type,
sal emp.sal%type,
hiredate emp.hiredate%type);
v_increase_sal number := &p_increase_sal;
emp_record emp_record_type;
begin
 select empno,ename,job,sal,hiredate into emp_record -- 可以把一行数据存储在记录数据类型里
 from emp_pl
 where empno=emp_record.empno; -- 记录类型.字段
 dbms_output.put_line(emp_record.hiredate||emp_record.sal);
 emp_record.hiredate:=sysdate;
 emp_record.sal:=emp_record.sal+v_increase_sal;
  dbms_output.put_line(emp_record.empno||','||emp_record.ename||','||emp_record.sal);
   dbms_output.put_line(emp_record.hiredate);
   end;

-- 1.2 使用%rowtype
%ROWTYPE 本身定义的是一个记录类型，用于存储单行数据。因此，使用 %ROWTYPE 声明的变量一次只能存储一行数据
-- 语法
--identifier reference%rowtype; 这里identifier是记录名 reference是表名/试图名等
    --eg 
--    declare
--    dept_record dept%rowtype; dept_record 是记录名 他的结构和dept表结构一致
-- 案例使用%rowtype
set verify off
set serveroutput on 
declare 
ex_emp_record emp_pl%rowtype; -- 声明一个record，结构完全复制emp_pl
begin
select * into ex_emp_record from emp_pl where empno=&emp_no;
insert into ex_emp values
(ex_emp_record.empno,ex_emp_record.ENAME,
ex_emp_record.JOB,
ex_emp_record.MGR,
ex_emp_record.HIREDATE,
ex_emp_record.SAL,
ex_emp_record.COMM,
ex_emp_record.DEPTNO,
sysdate);-- 下面案例介绍如何不需要列出所有列的值
commit;
end;


desc emp_pl;
-- 案例使用%rowtype进行插入和修改记录
-- 插入
set verify off
declare 
v_emp_record ex_emp%rowtype;
begin
select EMPNO,ENAME,JOB ,MGR,HIREDATE ,SAL,COMM,DEPTNO,HIREDATE 
into v_emp_record from emp_pl 
where empno=&p_empno;-- 因为emp_pl没有leavedate所以用HIREDATE替代，后面修改
insert into ex_emp values v_emp_record; -- 这里只需要把记录类型插入即可，就不需要向上面一样，逐个插入
 end;
-- 修改，我们需要把leavedate修改
declare 
v_emp_record ex_emp%rowtype;
begin
select EMPNO,ENAME,JOB ,MGR,HIREDATE ,SAL,COMM,DEPTNO,HIREDATE 
into v_emp_record from ex_emp 
where empno=&p_empno;
v_emp_record.leavedate:=current_date; -- 直接给记录变量赋值
update ex_emp 
set row=v_emp_record -- 直接改变整个row
where ex_emp.empno=v_emp_record.empno ; 
commit;
 end;

--2.PL/SQL集合 分为3类：
--1）关联数组，也称为索引表（Index-by Table）也叫PL/SQL表
--index by表中的主键，代表的是数组的下标 一般是整数或字符串类型  整数一般用binary_integer/pls_integer,下标可以为负值
-- 一般用标量数据类型或者记录数据类型的列来存储值， 如果是标量数据类型，那么一个下标只能存储一个值，如果是记录数据类型，那么一个下标可以存储多个值
    -- type 数据类型名 is table of   列数据类型
    --举例--    declare
--     type ename_table_type is table of emp.ename%type; -- 这里列数据类型是emp.ename的数据类型 ename_table_type是数据类型的名称
--     index by pls_integer;-- 下标类型为数字型
--     ename_table ename_table_type; -- 实例化
set verify off
set serveroutput on
 declare 
 type ename_table_type is table of emp_pl.ename%type
 index by pls_integer;
 type hiredate_table_type is table of date
 index by binary_integer;
 ename_table ename_table_type;
 hiredate_table hiredate_table_type;
 v_count number :=&p_count;
 begin
 for i in 1..v_count loop
 ename_table(i):='武大';
 hiredate_table(i):=sysdate+14;
 dbms_output.put_line(ename_table(i)||':'||hiredate_table(i));
 end loop;
 end;
 --1）Index-by Table的方法
 -- 1.1 EXISTS用法
 DECLARE
    -- 定义一个INDEX BY表类型，用于存储员工信息
    TYPE employee_table_type IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;   
    employee_table employee_table_type;
    v_employee_id number:=&p_num;
BEGIN
    employee_table(1) := 'Alice';
    employee_table(2) := 'Bob';
    employee_table(3) := 'Charlie';    
    DBMS_OUTPUT.PUT_LINE('Total number of employees: ' || employee_table.COUNT); -- COUNT用法
    IF employee_table.EXISTS(v_employee_id) THEN
        DBMS_OUTPUT.PUT_LINE('Employee with ID ' || v_employee_id || ' exists: ' || employee_table(v_employee_id));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Employee with ID ' || v_employee_id || ' does not exist');
    END IF;
    end;
    
 -- 1.2 first/last next/sprior用法 
declare 
type emp_num_type is table of number index by varchar2(38); -- 索引下标用字符串
total_number emp_num_type; --实例
i varchar2(38);
begin
select count(*) into total_number('account') from emp_pl where deptno=10; --account是索引下标
select count(*) into total_number('research') from emp_pl where deptno=30;
select count(*) into total_number('sales') from emp_pl where deptno=20;
i:= total_number.First ;-- 第一个值，i的取值在[account,research,sales]
DBMS_OUTPUT.PUT_LINE('按照升序列出每个部门名称和员工总数:');
while i is not null loop
dbms_output.put_line('total number of employee in '||i||'is:'||total_number(i)); 
i:= total_number.next(i); -- first和next是一组
end loop;
DBMS_OUTPUT.PUT_LINE('按照降序列出每个部门名称和员工总数:');
i:= total_number.last ; -- last和prior是一组
while i is not null loop
dbms_output.put_line('total number of employee in '||i||'is:'||total_number(i)); 
i:= total_number.prior(i);
end loop;
end;
 -- 1.3 index by记录表用法  存放整行数据
     -- 1）语法
--     declare
--     type dept_table_type is table of dept%rowtype index by pl_integer;
--     dept_table dept_table_type;
    -- 2）记录表中的元素例子
--    dept_table(research).loc:='黑风口' -- 索引叫research ，字段名叫loc
--        3）完整的index by 表案例
-- 先装进dept_table，再逐个打印
set verify off
set serveroutput on
declare
type dept_table_type is table of dept_pl%rowtype index by pls_integer;
dept_table dept_table_type;
v_count number :=5;
j number;
begin
for i in 1..v_count loop
select * into dept_table(i*10) from dept_pl where deptno=i*10;
end loop;
j:=dept_table.first;
while j is not null loop 
dbms_output.put_line(dept_table(j).deptno||' '||dept_table(j).dname||' '||dept_table(j).loc);
j:=dept_table.next(j);
end loop;
end;

--1）嵌套表（Nested Tables）
--1）变长数组（VARRAY）
