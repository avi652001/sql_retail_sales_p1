-- Sql Reatl Sales Analysis 

create database sql_project_p1;
use sql_project_p1 ; 
 
 create table retail_sales(
 transaction_id int primary key,
 sale_date date,
 sale_time time,
 customer_id int,
 gender varchar(15),
 age int,
 category varchar(15),
 quantity int,
 price_per_unit int,
 cogs float,
 total_sale float 
 
  ) ;
  select * from retail_sales;
  
-- then import the data -- 

select count(*)
from retail_sales;

--  if we same null so how to check null values 
select * from retail_sales 
where transaction_id is null; --  for signal
-- data cleaning --  
select * from retail_sales 
where 
     transaction_id is null
     or 
     sale_date  is null 
     or 
     sale_time is null 
     or
     gender is null 
     or
     age is null
     or
     category is null
     or
     quantity is null 
     or
     price_per_unit is null 
     or
     cogs is null
     or
     total_sale is null;
delete from retail_sales 
where
transaction_id is null
     or 
     sale_date  is null 
     or 
     sale_time is null 
     or
     gender is null 
     or
     age is null
     or
     category is null
     or
     quantity is null 
     or
     price_per_unit is null 
     or
     cogs is null
     or
     total_sale is null;
     
-- data Explorstion 
-- how many sale we have?
select count(*) as total_sale from
retail_sales;

-- how many unique customer we have?
select count(distinct customer_id) as total_customer from
retail_sales;
-- how many unique category we have?

select distinct category from retail_sales;
-- Data Analysis & Business Key Problems & Answers
 
select * from retail_sales;

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
 select * from retail_sales 
 where sale_date = '2022-11-05';
 
 -- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold 
 -- is more than 4 in the month of Nov-2022
select *
  from retail_sales
  where category ="Clothing"
     and 
      date_format(str_to_date(sale_date, '%Y-%m-%d'), '%Y-%m') = '2022-11'
      and quantity = 4 ;
      
--  Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_sale
FROM retail_sales
group by 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000 ;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
	select
		  year,
		  month,
		  avg_sale
	from
	(
	select 
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM SALE_DATE) ORDER BY AVG (TOTAL_SALE)DESC) as ranks
	from retail_sales
	group by 1,2
	)as t1
	where ranks=1;
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT
	customer_id,
    sum(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
as( 
select *, case 
        when extract(hour from sale_time) < 12 then 'morning'
        when extract(hour from sale_time) between 12 and 17  then 'Afternoon'
        else 'evening'
	end as shift
from retail_sales )
select  shift,
   count(*) total_orders
   from hourly_sale
   group by shift;

-- End of project

  
