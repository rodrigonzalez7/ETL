/* Tables should follow a name structure that contains the processing date of the table or 
any part that allow sorting the table names by any order, for example:

202301_TableNeeded
202302_TableNeeded
202303_TableNeeded

*/
USE DatabaseName

Declare		@Query varchar(max)
Declare		@TablesNeeded table (TableName varchar(100))
Declare		@i int = 0
Declare		@NumTablas int = 0
Declare		@ProcessedTable varchar(20)

Insert Into @TablesNeeded
Select		TABLE_NAME
from		ServerName.DatabaseName.information_schema.tables
where		Table_name like '%_TableNeeded%'
order by	TABLE_NAME desc

set @NumTablas = (Select COUNT(*) from DatabaseName.information_schema.tables 
				where Table_name like '%_TableNeeded%' ) 

While	(@i <  @NumTablas
		)
	BEGIN	
		IF @NumTablas - @i <> 1 --Commands until n-1 should finish in UNION
			BEGIN
			Set		@ProcessedTable = (Select top 1* From @TablesNeeded)
			Set		@Query = Concat(@Query,
					'
					Select	* From [',@ProcessedTable,']
					UNION')
			END
		ELSE  --The last command should not finish in UNION
			BEGIN
		
					Set		@ProcessedTable = (Select top 1* From @TablesNeeded)
			Set		@Query = Concat(@Query,
					'
					Select	* From [',@ProcessedTable,']')
			END
		Delete From @TablesNeeded Where TableName = @ProcessedTable
		Set @i = @i +1
	End

--print @Query
Exec	sp_sqlexec @Query 
