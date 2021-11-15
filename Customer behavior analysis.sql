--DATA PREPARATION 

create database DB_TASK

---Q1

Select 'customer_Id' as [Table Name], 
count(*) as [No. of Records] 
from [dbo].[Customer]
union all
select 'cust_id' as [Table Name], 
count(*) as [No. of Records] 
from [dbo].[Transactions]
union all
select 'prod_cat_code' as [Table Name], 
count(*) as [No. of Records] 
from [dbo].[prod_cat_info] 


--Q2

Select 
count(total_amt) as [Total Trans Return]
from [dbo].[Transactions]
where total_amt<0

--Q3

alter table [dbo].[Transactions] alter column tran_date date
alter table [dbo].[Customer]  alter column DOB date 

Select * from [dbo].[Customer]

----Q4

select
min(tran_date) as [Min], 
max(tran_date) as [Max],
datediff(year,min(tran_date),max(tran_date)) as [Year],
datediff(Month,min(tran_date),max(tran_date)) as [Months],
datediff(Day,min(tran_date),max(tran_date)) as [Days]
from [dbo].[Transactions]

---Q5

select * 
from [dbo].[prod_cat_info]
where prod_subcat = 'DIY'

----DATA ANALYSIS-----

---Q1

select
Store_type as [Channels], 
count(*) as [records]
from
[dbo].[Transactions]
Group by 
Store_type
having
count(*) > 5000

---Q2

SELECT
count(Gender) as [Total Males and Female]
from [dbo].[Customer]
where Gender = 'M' 
union all
SELECT
count(Gender) as [Total Males and Female]
from [dbo].[Customer]
where Gender = 'F'

--Q3

Select 
top 1
city_code,
count(city_code) as mycount
from [dbo].[Customer]
group by 
city_code
order by 
mycount desc
 
----Q4

select *
from [dbo].[prod_cat_info]
where prod_cat = 'Books'

--- Q5

Select
max(Qty) as [Max Quantity]
from [dbo].[Transactions] 

--Q6

select 
sum (total_amt) as [Total Revenue]
from [dbo].[prod_cat_info] T1
inner join
[dbo].[Transactions] T2 on T1.prod_cat_code = T2.prod_cat_code and T1.prod_sub_cat_code = T2.prod_subcat_code
where prod_cat = 'Electronics' or prod_cat = 'Books'


--Q7

select
cust_id as [Customer],
count(cust_id) as [no.of Transtacion]
from 
[dbo].[Transactions] 
where total_amt > 0
group by
cust_id
having
count(cust_id) > 10

--Q8

select
Store_type,
sum(total_amt) as [Combined Revenue]
from [dbo].[Transactions] t1
inner join
[dbo].[prod_cat_info] t2 on t2.prod_cat_code = t1.prod_cat_code
where  Store_type = 'Flagship store' and prod_cat in ('Clothing' ,'Electronics')
group by
Store_type

--Q9

Select
prod_subcat,
Sum(total_amt) as [total Revenue]
from 
[dbo].[Customer]t1
inner join
[dbo].[Transactions] t2 on t2.cust_id = t1.customer_Id
inner join
[dbo].[prod_cat_info] t3 on t3.prod_cat_code = t2.prod_cat_code
where Gender = 'M' and prod_cat = 'Electronics'
group by
prod_subcat

--Q10

Select
prod_subcat_code,
case when (total_amt * 100 /(select sum(total_amt)  from [dbo].[Transactions]) then total_amt else 0  end as Totalrevenue,
case when (total_amt * -100 /(select sum(total_amt)  from  [dbo].[Transactions] where total_amt < 0) then total_amt else 0  end as TotalReturn
from
[dbo].[Transactions]
group by
prod_subcat_code,
total_amt

select
prod_subcat_code as [Sub Cat],
sum(total_amt) as [sales],

case 
  when total_amt > 0 end as 'revenue',
case 
  when total_amt < 0 end as 'return'
 
from 
[dbo].[Transactions]
group by
prod_subcat_code,
total_amt

union all
select top 5
prod_subcat_code as [Sub Cat],
sum(total_amt) as [Return]
from 
[dbo].[Transactions]
where total_amt < 0
group by
prod_subcat_code
	

--Q11

select
cust_id,
max(tran_date) as [maxDate],
datediff(day,max(tran_date),(select max(tran_date) from [dbo].[Transactions])) as [Days],
sum(total_amt) as [revenue],
datediff(year,min(DOB),max(tran_date)) as [Age]
from
[dbo].[Transactions]
left join
[dbo].[Customer] on cust_id = customer_Id
group by
cust_id,
tran_date
having
datediff(year,min(DOB),max(tran_date)) >= 25 
and 
datediff(year,min(DOB),max(tran_date)) <= 35 
and 
datediff(day,max(tran_date),(select max(tran_date) from [dbo].[Transactions])) between 0 and 30
order by
max(tran_date) desc

--Q12

select
prod_cat_code,
sum(total_amt) as [Return],
datediff(month,max(tran_date),(select max(tran_date) from [dbo].[Transactions])) as [Age]
from
[dbo].[Transactions]
where
total_amt < 0
group by
prod_cat_code
having 
datediff(month,max(tran_date),(select max(tran_date) from [dbo].[Transactions])) between 0 and 3 
order by
sum(total_amt) 

--Q13

select
Store_type as [store],
sum(Qty) as [Quantity],
sum(total_amt) as [sales]
from 
[dbo].[Transactions]
group by
Store_type
order by
sum(total_amt) desc

--Q14

select
prod_cat_code as [Product Category],
AVG(total_amt) as [Average Revenue]
from
[dbo].[Transactions]
group by
prod_cat_code
having AVG(total_amt) > (select
avg(total_amt)
from
[dbo].[Transactions])
order by prod_cat_code desc

--Q15

select 
prod_subcat_code,
Avg(total_amt) as [Average Total_amt],
sum(total_amt) as  [Total_amt]
from
(select
top 5
prod_cat_code,
sum(total_amt) as [Total]
from
[dbo].[Transactions]
group by
prod_cat_code) t1
inner join
[dbo].[Transactions] t2 on t2.prod_cat_code = t1.prod_cat_code
group by
prod_subcat_code
order by
sum(total_amt) desc





select
prod_sub_cat_code,
total_amt as [total quantity]
from
[dbo].[Transactions] T1
inner join
[dbo].[prod_cat_info] T2 on T2.prod_sub_cat_code = T1.prod_subcat_code
where Qty > 0
group by
prod_sub_cat_code,
total_amt

	



















