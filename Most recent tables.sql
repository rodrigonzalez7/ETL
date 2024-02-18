--Query to get the most recent table from a database with DAILY tables
/*For this query to work, information must be stored in the format:

DatabaseName.dbo.TableNameFixedPart310124
DatabaseName.dbo.TableNameFixedPart300124
DatabaseName.dbo.TableNameFixedPart290124
...
DatabaseName.dbo.TableNameFixedPart020124
DatabaseName.dbo.TableNameFixedPart010124
DatabaseName.dbo.TableNameFixedPart311223
*/
Declare @Query as varchar(1000)
Declare @Table as varchar(50)
Declare @i as int 
Set		@i = 1
Set		@Table = Concat('DatabaseName.dbo.TableNameFixedPart', FORMAT(CAST( DATEADD(day,-@i, GETDATE()) AS DATE), 'ddMMyy'))
Set		@Query = CONCAT('Select Field1, Field2, Field3, Field4,
	FROM DatabaseName.dbo.TableNameFixedPart',FORMAT(CAST( DATEADD(day,-@i, GETDATE()) AS DATE), 'ddMMyy'))
While (OBJECT_ID(@Table) is null)
Begin 
	Set @i = @i + 1
	Set		@Table = Concat('DatabaseName.dbo.TableNameFixedPart', FORMAT(CAST( DATEADD(day,-@i, GETDATE()) AS DATE), 'ddMMyy'))
End
Set		@Query = CONCAT('Select Field1, Field2, Field3, Field4,
	FROM DatabaseName.dbo.TableNameFixedPart',FORMAT(CAST( DATEADD(day,-@i, GETDATE()) AS DATE), 'ddMMyy'))
Exec sp_sqlexec @Query

--Query to get the most recent table from a database with MONTHLY tables
/*For this query to work, information must be stored in the format:

DatabaseName.dbo.TableNameFixedPart310124
DatabaseName.dbo.TableNameFixedPart311223
DatabaseName.dbo.TableNameFixedPart301123
...
DatabaseName.dbo.TableNameFixedPart310123
DatabaseName.dbo.TableNameFixedPart311222
DatabaseName.dbo.TableNameFixedPart301122
*/

--Query to get the latest monthly table
Declare @Query as varchar(1000)
Declare @Table as varchar(50)
Declare @i as int 
Set		@i = 1
Set		@Table = Concat('DatabaseNameFixedPart.dbo.TableNameFixedPart', FORMAT( EOMONTH(CAST( DATEADD(MONTH,-1, GETDATE()) AS DATE)), 'ddMMyy'))
Set		@Query = CONCAT('Select FieldName1, FieldName2, FieldName3
		FROM DatabaseName.dbo.TableNameFixedPart',FORMAT(EOMONTH(CAST( DATEADD(MONTH,-1, GETDATE()) AS DATE)), 'ddMMyy'))
While (OBJECT_ID(@Table) is null)
Begin 
	Set @i = @i + 1
	Set		@Table = Concat('DatabaseNameFixedPart.dbo.TableNameFixedPart', FORMAT( EOMONTH(CAST( DATEADD(MONTH,-1, GETDATE()) AS DATE)), 'ddMMyy'))
End
Set		@Query = CONCAT('Select FieldName1, FieldName2, FieldName3
		FROM DatabaseName.dbo.TableNameFixedPart',FORMAT(EOMONTH(CAST( DATEADD(MONTH,-1, GETDATE()) AS DATE)), 'ddMMyy'))
Exec sp_sqlexec @Query