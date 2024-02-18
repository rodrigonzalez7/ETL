DECLARE @columns NVARCHAR(MAX) = '',
		@sql NVARCHAR(MAX) = '';
SELECT @columns += QUOTENAME(A.ColumnNameToPivot) + ','
FROM	(Select distinct ColumnNameToPivot
		FROM [DatabaseName].[dbo].[TableName]
		) A
ORDER BY A.ColumnNameToPivot;
SET @columns = LEFT(@columns, LEN(@columns) - 1);
--PRINT @columns;


Set @sql = '
Select *
from
	(
	SELECT ColumnNameToPivot, RowsField1, FieldToAggregate --VALORES QUE QUEDARÁN EN COLUMNAS NO PIVOTEADAS
	From [DatabaseName].[dbo].[TableName]) A
PIVOT(
	count(FieldToAggregate) 
	for  ColumnNameToPivot IN ('+@columns+') 
) AS MyPivotTable
Order by RowsField1'

--print @sql
EXEC sp_sqlexec @sql