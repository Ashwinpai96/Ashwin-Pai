CREATE DATABASE Retail_Sales_analysis;

--Creating table
Drop table if exists Retail_sales;
Create Table Retail_sales
            (
				transactions_id	INT primary key,
				sale_date date,
				sale_time time,	
				customer_id	int,
				gender	varchar(15),
				age	int,
				category varchar(50),
				quantity	int,
				price_per_unit float,
				cogs float,
				total_sale float
			);
            
Select * from Retail_sales;
Limit 10

/* Data Exploration & Cleaning
Record Count: Determine the total number of records in the dataset.
Customer Count: Find out how many unique customers are in the dataset.
Category Count: Identify all unique product categories in the dataset.
Null Value Check: Check for any null values in the dataset and delete records with missing data.
*/
--Total Count of transaction_id
select count(*) from Retail_sales;

--Customer Count
Select count(Distinct customer_id) from Retail_sales;

--Category Count
select Distinct category from retail_sales;

--Null Value Check
select * from retail_sales
where
transactions_id IS NULL
OR
 sale_date IS NULL
 OR
 sale_time IS NULL
 OR
 customer_id IS NULL
 OR 
 gender IS NULL
 OR
 age IS NULL
 OR
 category IS NULL
 OR
 quantity IS NULL
 OR
 price_per_unit IS NULL
 OR
 cogs is NULL
 OR
 total_sale IS NULL;

Delete from retail_sales
where
sale_date is NULL or sale_time is NULL or customer_id is NULL or gender is NULL or age is NULL 
or category is NULL or quantity is NULL or price_per_unit is NULL or cogs is NULL;

-- Data Analysis & Findings
-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:

Select * from retail_sales
where sale_date = '2022-11-05';

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
    
--Write a SQL query to calculate the total sales (total_sale) for each category.:

select category,sum(total_sale) as net_sales,count(*) AS total_orders
from retail_sales
group by 1;

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age),2) as Avg_age from retail_sales
where category = 'Beauty';

--Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000;

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category,gender,count(*)as total_transactions
from retail_sales
group by category,gender
order by 1

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

select sale_year,sale_month,avg_sale
from
(
	select 
   		year (sale_date) as sale_year,
       	month (sale_date) as sale_month,
        Avg (total_sale) as avg_sale,
 		Rank() Over(Partition by year(sale_date) order by Avg(total_sale) Desc) as rnk
	from retail_sales	
	group by 1,2
   	) as T1
where rnk = 1;

--Write a SQL query to find the top 5 customers based on the highest total sales

select customer_id,Sum(total_sale) as total_sale
 from retail_sales
 group by 1
 order by 2 desc
 limit 5;

Write a SQL query to find the number of unique customers who purchased items from each category.

select count(distinct customer_id) from retail_sales
group by category

Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

With hourly_sale 
AS
(
Select *,
case
when hour(sale_time) < 12 then 'Morning'
when hour(sale_time) between 12 and 17 then 'Afternoon'
Else 'Evening'
end as shift
 from retail_sales
 ) 
 Select shift, count(*) as total_orders
 from hourly_sale
 group by shift;



























