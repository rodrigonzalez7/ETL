/* Data is stored in a table with the format:
Field 1 | 202301 | 202302 | 202303 | ... | 202312
--------------------------------------------------
Value1  | 200    |  250   |  520   | ... | 340


And we want to obtain:
Field1 | Month  | Amount 
-------------------------
Value1 | 202301	| 200
Value1 | 202302	| 250
Value1 | 202303	| 520
...
Value1 | 202312	| 340
*/

DECLARE @columns NVARCHAR(MAX) = '',
		@sql NVARCHAR(MAX) = '';
SELECT @columns += QUOTENAME(A.COLUMN_NAME) + ','
FROM	(
		SELECT COLUMN_NAME
		FROM DatabaseName.INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'TableNameNeeded'
		and COLUMN_NAME like '%ColumnNameNeeded%'
) A
ORDER BY A.COLUMN_NAME;
SET @columns = LEFT(@columns, LEN(@columns) - 1);

--print @columns
Set @sql = '
Select Field1, RIGHT(Date,6) as Month, Amount
from
	(
	SELECT Field1, '+ @columns+'
	From [DatabaseName].[dbo].[TableNameNeeded]) A
UNPIVOT(
	Amount FOR Month IN
	('+@columns+')
) AS MyPivotTable
'

--print @sql
EXEC sp_sqlexec @sql