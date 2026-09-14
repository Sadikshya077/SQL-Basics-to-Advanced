set statistics time on;
select * from sales.customers; -- we cannot use * as it take much time so we write columns name
set statistics time off;

set statistics time on;  -- used to check time of execution
set nocount on; -- to disable showing number of rows affected to reduce processing time
select customer_id, first_name, last_name, phone, email, street, city, state, zip_code
from sales.customers;
set statistics time off;

-- Concat Function() and Concatenation Operator(+)
select CONCAT(first_name,' ', last_name) as customer_name from sales.customers;

select (first_name + ' ' + last_name) as customer_name from sales.customers
-- the difference is when we use + it cannot merge integer and string 

select concat (product_name, list_price) from production.products;

-- select product_name + list_price from production.products; throws error

-- SubString, Left, Right
-- Extracting range of letters from text

/*
	SubString(col_name, start_value, number_of_values_to_extract)

	Left(col_name, number_of_values_to_extract)
	Right(col_name, number_of_values_to_extract)
*/

select first_name, substring(first_name, 2,3) as extracted_letters,
left(first_name,3) as first_3_letters,
right(first_name,3) as last_3_letters
from sales.customers;

select concat(customer_id, '-', substring(first_name,2,3),'-',right(last_name,2))
as unique_customer_id
from sales.customers;

-- Date Functions

select order_date , YEAR(order_date) as y_date,
MONTH(order_date) as m_date,
DAY(order_date) as d_date,
datepart(quarter, order_date) as quarter_num,
DATEPART(WEEK, order_date) as week_number,
datename(weekday, order_date) as week_name,
datepart(WEEKDAY, order_date) as weekday_num,
datename (month, order_date) as month_name,

FORMAT(order_date, 'M') as order_month, -- M and d are case sensitive
FORMAT(order_date, 'dddd') as day_name
from sales.orders;

select order_date, required_date, shipped_date, isnull(shipped_date, getdate()) as filled_date,
DATEDIFF(DAY, order_date,isnull(shipped_date, getdate())) as day_diff,
dateadd(day, 2, required_date) as day_added
from sales.orders;

-- Fill values temporary
-- isnull / coalesce

select shipped_date, isnull(shipped_date, getdate()) as filled_date
from sales.orders;

select shipped_date, isnull(shipped_date, getdate()) as filled_date,
coalesce(shipped_date, getdate()) --gives time as well
from sales.orders;