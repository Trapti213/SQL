CREATE TABLE sales (name varchar(30), order_date date, sales NUMERIC(5,2));

INSERT INTO sales values ("Archit",'2020-12-01 00:00:00', 80.00);
INSERT INTO sales values ("Archit",'2020-12-02 00:00:00', 70.00);
INSERT INTO sales values ("Archit",'2020-12-03 00:00:00', 40.00);
INSERT INTO sales values ("Archit",'2020-12-04 00:00:00', 90.00);
INSERT INTO sales values ("Archit",'2020-12-05 00:00:00', 10.00);
INSERT INTO sales values ("Archit",'2020-12-06 00:00:00', 20.00);
INSERT INTO sales values ("Archit",'2020-12-07 00:00:00', 40.00);

INSERT INTO sales values ("Gaurav",'2020-12-01 00:00:00', 90.00);
INSERT INTO sales values ("Gaurav",'2020-12-02 00:00:00', 40.00);
INSERT INTO sales values ("Gaurav",'2020-12-03 00:00:00', 40.00);
INSERT INTO sales values ("Gaurav",'2020-12-04 00:00:00', 30.00);
INSERT INTO sales values ("Gaurav",'2020-12-05 00:00:00', 90.00);
INSERT INTO sales values ("Gaurav",'2020-12-06 00:00:00', 10.00);
INSERT INTO sales values ("Gaurav",'2020-12-07 00:00:00', 40.00);

INSERT INTO sales values ("Trapti",'2020-12-01 00:00:00', 10.00);
INSERT INTO sales values ("Trapti",'2020-12-02 00:00:00', 100.00);
INSERT INTO sales values ("Trapti",'2020-12-03 00:00:00', 90.00);
INSERT INTO sales values ("Trapti",'2020-12-04 00:00:00', 20.00);
INSERT INTO sales values ("Trapti",'2020-12-05 00:00:00', 90.00);
INSERT INTO sales values ("Trapti",'2020-12-06 00:00:00', 20.00);
INSERT INTO sales values ("Trapti",'2020-12-07 00:00:00', 60.00);


select name, sum(sales) 
from sales
group by 1


----Finding the Contribution of Person in Total Sales----
select distinct 
	   name,
	   sum(sales) over (partition by name order by name ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as tot_sales,
	   sum(sales) over (partition by name order by name ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)  * 100/ sum(sales) over (order by name ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as tot_sales_perct
from sales

-----Finding the running sum for each person at day level----
select distinct 
	   name,
	   sales,
	   order_date,
	   sum(sales) over (partition by name order by order_date ROWS UNBOUNDED PRECEDING) as tot_sales
from sales

----Finding Running sum for each person at day level without using window functions----

select distinct s1.name, s1.order_date, sum(s2.sales)
from sales s1, sales s2
where s1.order_date >= s2.order_date 
and s1.name = s2.name 
group by 1,2




------Finding the running% for each person at day level------
select distinct 
	   name,
	   sales,
	   order_date,
	   (sum(sales) over (partition by name order by order_date ROWS UNBOUNDED PRECEDING))*100 /
	   (sum(sales) over (partition by name ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING))
from sales

------Finding the 3 day moving average for each person ------

select distinct 
	   name,
	   sales,
	   order_date,
	   sum(sales) over (partition by name ORDER BY order_date ROWS 3 PRECEDING)
from sales


-------Finding the 7 day moving average for each person on their last day of transaction ------

with base as (
select distinct 
	   s.name,
	   s.sales,
	   s.order_date,
	   sum(s.sales) over (partition by s.name ORDER BY order_date ROWS 7 PRECEDING) as seven_day_running_sum
from sales s
) 
select base.name,
	   base.sales,
	   base.order_date,
       base.seven_day_running_sum
from base base
left join 
(select name, max(order_date) as ord_date from sales group by 1) as t2
where base.name = t2.name and base.order_date = t2.ord_date 
