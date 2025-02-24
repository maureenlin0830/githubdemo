--if then elsif 语句实例 要以end if结束
alter session set NLS_DATE_LANGUAGE='American';
set verify off
set serveroutput on
declare
v_shipdate date:='&p_shipdate';
v_orderdate date:='&p_orderdate';
v_ship_flag varchar2(16);
begin
if v_shipdate-v_orderdate<8 then v_ship_flag:='acceptable';
dbms_output.put_line('这家公司不错');
elsif
v_shipdate-v_orderdate<12 then v_ship_flag:='pass';
dbms_output.put_line('这家公司一般');
else
v_ship_flag:='unacceptable';
dbms_output.put_line('这家公司服务态度太差了');
end if;
dbms_output.put_line(v_ship_flag);
end;

--case 语句实例
--case selector 例子 这里是case表达式，case表达式以end结束，根据when的条件返回不同的结果
 set verify off
set serveroutput on
declare v_degree char(1):=upper('&p_degree');
v_description VARCHAR(250);
BEGIN
v_description:= 
case v_degree 
when 'B' then '此人拥有学士学位'
when 'M' then '此人拥有硕士学位'
when 'D' then '此人拥有博士学位'
else  '此人拥有壮士学位'
END ;
DBMS_OUTPUT.PUT_LINE(v_description);
END;
--case语句，必须以end case结尾
declare v_degree char(1):=upper('&p_degree');
BEGIN
case  
when v_degree='B' then DBMS_OUTPUT.PUT_LINE('此人拥有学士学位');
when v_degree='M' then DBMS_OUTPUT.PUT_LINE('此人拥有硕士学位');
else DBMS_OUTPUT.PUT_LINE('此人拥有壮士学位');
END case;
END;

-- case 综合案例
set verify off
set serveroutput on 
declare
v_empno number :=&p_empno;
v_name varchar(30);
v_job emp.job%type;
v_sal emp.sal%type;
begin
-- 选出特定员工的工种
select job into v_job from emp_pl where empno=v_empno;
-- 根据不同的职位选择不同的加薪幅度 销售15%，文员20%，分析员25%，经理40%
case v_job
when  'SALESMAN' THEN 
SELECT EMPNO,ENAME,JOB,SAL*1.15 INTO V_EMPNO,V_NAME,V_JOB,V_SAL FROM EMP_PL WHERE EMPNO=V_EMPNO;
DBMS_OUTPUT.PUT_LINE(v_job||'-'||V_NAME||'加薪后的工资是'||V_SAL);
when  'CLERK' THEN 
SELECT EMPNO,ENAME,JOB,SAL*1.2 INTO V_EMPNO,V_NAME,V_JOB,V_SAL FROM EMP_PL WHERE EMPNO=V_EMPNO;
DBMS_OUTPUT.PUT_LINE(v_job||'-'||V_NAME||'加薪后的工资是'||V_SAL);
when  'ANALYST' THEN 
SELECT EMPNO,ENAME,JOB,SAL*1.25 INTO V_EMPNO,V_NAME,V_JOB,V_SAL FROM EMP_PL WHERE EMPNO=V_EMPNO;
DBMS_OUTPUT.PUT_LINE(v_job||'-'||V_NAME||'加薪后的工资是'||V_SAL);
when  'MANAGER' THEN 
SELECT EMPNO,ENAME,JOB,SAL*1.4 INTO V_EMPNO,V_NAME,V_JOB,V_SAL FROM EMP_PL WHERE EMPNO=V_EMPNO;
DBMS_OUTPUT.PUT_LINE(v_job||'-'||V_NAME||'加薪后的工资是'||V_SAL);
END CASE;
END;
SELECT * FROM EMP_PL WHERE EMPNO=7782;

-- GOTO语句
set verify off
set serveroutput on 
declare v_num number :=&p_number;
v_count number :=0;
begin<<loop_start>> -- 一定要用<<>>把循环开始标注
if v_count=0 then DBMS_OUTPUT.PUT_LINE('这个数字是0');
elsif v_count<2 then DBMS_OUTPUT.PUT_LINE('1小于2');
elsif (v_count mod 2)<>0 then DBMS_OUTPUT.PUT_LINE(v_count||'这个数是奇数');
elsif (v_count mod 2 ) =0 then DBMS_OUTPUT.PUT_LINE(v_count||'这个数是偶数');
end if;
v_count:=v_count+1;
if v_count<=v_num then 
goto loop_start;
end if;
end;
