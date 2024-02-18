--Update field of a table based on information spread on monthly tables in anual databases
/*
For this query to work , the databases should follow the name structure:
data_21
data_22
data_23

And the tables inside each database should follow the structure:
Table301123
Table311223
*/

Declare @DateStart	date = '2021-01-31'
Declare @DateEnd date = '2023-12-31'
Declare	@Datei date = @DateStart --Iterator for each date; initialized in first date
Declare @Query1 varchar(max)


While	(@Datei <= @DateEnd)
Begin
	Set	@Query1 =
		Concat('
		UPDATE a 
		SET a.FieldToUpdate = b.SourceField
		FROM [DatabaseName].[dbo].[TableToUpdate] a, 
			[DatabaseNameFixedPart', Format(@Datei, 'yy'),'_a].[dbo].[TableNameFixedPart', 
		Format(@Datei, 'ddMMyy'),'] b 
		WHERE a.MatchingField1 = b.MatchingField1')
	--print @Query1
	Exec sp_sqlexec @Query1

	Set @Datei = EoMonth( DateAdd(Month, 1, @Datei)) --Changes date value to the last day of the next month
End
