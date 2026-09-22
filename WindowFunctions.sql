/*
	Window Functions
	----------------------
	1. Row_Number() -> To give each row unique identifying value, Find and remove duplicate data
	2. Rank() -> Ranking data -> skips row number
	3. Dense_Rank() -> Ranking data -> Doesn't skip row number. Used to find nth highest data.
	
	4. NTile(num) -> Divides data
	5. Lead(col_name, offset(optional)) -> Next Value
	6. Lag(col_name, offset(optional)) -> Previous Value
		offset -> how many rows to skip is 1 in default
	7. Running Sum -> Sum(col_name)
	8. Moving Average -> Avg(col_name)

	Syntax
	------------------
	select
		col1, col2, col3, col4
		win_func() over(partition by col_name order_by col_name)
	from table_name;

	here partition is grouping and is used only if we want it but order by is compulsory
*/


-- Row Number
select 
	Transaction_ID, USER_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction,
	Device_Used, Location, Previous_Fraudulent_Transactions, Account_Age,
	Number_of_Transactions_Last_24H, Payment_Method, Fraudulent,
	ROW_NUMBER() OVER(partition by Time_of_Transaction order by Transaction_Amount desc) as row_num--  by default desc
from Fraud.dbo.[Fraud Detection Dataset]; --if we don't want to change the database manually

-- we can do this simply as this but here the full data is not shown so we use window function
select Time_of_Transaction, COUNT(Transaction_ID)
from Fraud.dbo.[Fraud Detection Dataset]
group by Time_of_Transaction

-- finding duplicates by row number
select 
	Transaction_ID, USER_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction,
	Device_Used, Location, Previous_Fraudulent_Transactions, Account_Age,
	Number_of_Transactions_Last_24H, Payment_Method, Fraudulent,
	ROW_NUMBER() OVER(partition by Transaction_ID order by Transaction_ID desc) as row_num--  by default desc
from Fraud.dbo.[Fraud Detection Dataset]; 

-- here after each unique value in a row, the row number resets so every unique rows will have 1
-- but in case of duplicate transaction_id there will be two row number 1 and 2
-- in this way we find the duplicates


-- now we use CTE to remove the duplicate values
-- remove all data whose row_num is more than 1
with fraud_duplicate_data as (
	select 
	Transaction_ID, USER_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction,
	Device_Used, Location, Previous_Fraudulent_Transactions, Account_Age,
	Number_of_Transactions_Last_24H, Payment_Method, Fraudulent,
	ROW_NUMBER() OVER(partition by Transaction_ID order by Transaction_ID desc) as row_num--  by default desc
from Fraud.dbo.[Fraud Detection Dataset]
)
delete from fraud_duplicate_data where row_num >1;
-- it permanently removes the data on the basis of transaction id

-- Rank
select product_id, product_name, brand_id, category_id, model_year, list_price,
RANK() OVER(partition by brand_id order by list_price) as rank_num -- skips the value after ranking
from BikeStores.production.products

-- Dense Rank
select product_id, product_name, brand_id, category_id, model_year, list_price,
DENSE_RANK() OVER(partition by brand_id order by list_price) as dense_rank_num -- doesn't skip value
from BikeStores.production.products

select * from (
	select product_id, product_name, brand_id, category_id, model_year, list_price,
	DENSE_RANK() OVER(partition by model_year order by list_price) as dense_rank_num -- doesn't skip value
	from BikeStores.production.products
) as data
where dense_rank_num = 2 --gives second highest number

