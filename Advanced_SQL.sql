/*
	1. Indexing
	2. Views 
		-Normal view -> auto update
		-Materialized view -> doesn't auto update
	3. Synonyms
	4. Basic Stored Procedure
*/

-- Indexing
-- The columns with indexing takes less time for execution
--In a single table we can index 32 columns but we do maximum 3 along with primary key with their index

select * from production.products
where product_id =5 --has auto indexing 

select * from production.products 
where product_name like '%Trek%'; --  there is no index

create index idx_product_name on production.products(product_name); -- makes searching faster
-- now in the background instead of searching names, it search for index

/*
Reason why we do maximum of 3 columns indexing is because it creates problem during insertion and updation
as every time we insert a new row it also have to find for index by searching from top so it becomes slow.
*/

-----------------------------------------------------------------------------------------------------------------

--View
-- we place entire cte inside view
-- if someone ask for the query then we give it through view for making it secure

create or alter view vw_product_order as 
	with product_order as (
	select 
		so.customer_id, so.order_id, so.order_status, so.order_date,
		soi.list_price as order_price, soi.discount, soi.quantity, ((soi.list_price) * (soi.quantity) * (1-soi.discount))		
		as total_price, pp.product_id, pp.model_year, pp.list_price as product_price
		from sales.orders so
		join sales.order_items soi
		on so.order_id = soi.order_id
		join production.products pp
		on soi.product_id = pp.product_id
		where so.order_status in (1,3)
		and ((soi.list_price) * (soi.quantity) * (1-soi.discount)) >3000
		and pp.model_year = 2018
	)
	select concat(sc.first_name,' ',sc.last_name) as customer_name, total_price
	from product_order po
	join sales.customers sc
	on po.customer_id = sc.customer_id;

	-- while CTE is temporary view is now permanent, and ignore the error, it's just saying that there must be one view 

select * from vw_product_order; -- we give this query

-----------------------------------------------------------------------------------------------------------------------------

-- synonym
-- now to make it more secure we usually make synonym of the table name before giving the view code

create synonym p for vw_product_order; 

select * from p;   -- now we give this query instead

----------------------------------------------------------------------------------------------------------------------------

-- Stored Procedure 
create or alter procedure usp_product_order as 
	with product_order as (
	select 
		so.customer_id, so.order_id, so.order_status, so.order_date,
		soi.list_price as order_price, soi.discount, soi.quantity, ((soi.list_price) * (soi.quantity) * (1-soi.discount))		
		as total_price, pp.product_id, pp.model_year, pp.list_price as product_price
		from sales.orders so
		join sales.order_items soi
		on so.order_id = soi.order_id
		join production.products pp
		on soi.product_id = pp.product_id
		where so.order_status in (1,3)
		and ((soi.list_price) * (soi.quantity) * (1-soi.discount)) >3000
		and pp.model_year = 2018
	)
	select concat(sc.first_name,' ',sc.last_name) as customer_name, total_price
	from product_order po
	join sales.customers sc
	on po.customer_id = sc.customer_id;


exec usp_product_order;-- we provide just this query and they can just view neither update or do anything so it is more secure
select * from production.products;

--write stored procedure to filter product data using model_year and list_price

create or alter procedure usp_product_filter(
	@model_year int,
	@list_price decimal(10,2) = 9999999.99
) as 
begin
	select * from production.products
	where model_year = @model_year
	and list_price < @list_price;
end;

exec usp_product_filter @model_year=2016, @list_price = 1500 
-- if we don't give list_price then by default there exist a value according to which all list_price is seen in output


select * from sales.customers
-- Register customer (if email exist don't let them register and if not then let them register)
create or alter procedure usp_register_customer(
	@first_name varchar(50),
	@last_name varchar(50),
	@email varchar(50),
	@ResponseMessage Varchar(100) output
) as 
Begin
	if exists (select 1 from sales.customers where email= @email)
	begin 
		set @ResponseMessage = 'Email already exists, please use another email address to register into the system'
		return 
	end
	insert into sales.customers (first_name, last_name, email)
	values (@first_name, @last_name, @email);

	set @ResponseMessage = Concat ('Customer with email address', @email, 'registered')
End;

Declare @output_message varchar(100)
exec usp_register_customer @first_name='Bob', @last_name = 'Marston', @email ='bob.marston@yahoo.com', @ResponseMessage= @output_message output;
select @output_message as output


select * from sales.customers
where email = 'bob.marston@yahoo.com';
