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



