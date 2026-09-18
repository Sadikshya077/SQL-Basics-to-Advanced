/*
	SubQuery
	---------------
	1. Single row subquery 
		- If inner query provides with single row and single column data
		- Comparison Operator

	2. Multi row subquery
		- If inner query provides with multiple rows and single column
		- In (for discrete and categorical data), Any, All (for continuous data)

	3. Correlated subquery
		- It is used when with multi row subquery
		- If required used Exists

	Syntax
	------------------
	select * from table_name where col_name = (    -> outer query
		select * from table_name where col_name = data  -> inner query
	)
*/

-- Single row subquery
-- Find all order item details whose list_price is less than average list_price

-- without subquery we do it as first finding average and copying it's output to compare for all items:

select avg(list_price) from sales.order_items;

select * from sales.order_items where list_price < 1212.707;

-- with subquery we do it as: (always start from inner query)
select * from sales.order_items where list_price < (
	select avg(list_price) from sales.order_items
);

-- Find the second highest list_price from order_items.

select * from sales.order_items where list_price = (
	select max(list_price) from sales.order_items where list_price < (
		select max(list_price) from sales.order_items
	)
);  -- It has only one inner query, the entire two line code is inner query that outputs single row


-- Find the third day order from customer orders

select * from sales.orders

select * from sales.orders where order_date = (
	select min(order_date) from sales.orders where order_date > (
		select min(order_date) from sales.orders where order_date > (
			select min(order_date) from sales.orders 
			)
	)
);
