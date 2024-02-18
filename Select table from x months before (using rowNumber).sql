--This query has the assumption of a table with N periods of data
--The date of the data is stored in the field ProcessingDate
--We want to select the data from X periods back


--Select 
Select field1, field2, field3, field4, field5, 
FROM [DatabaseName].[dbo].[TableName]
Where ProcessingDate =
	(Select ProcessingDate
	From (
		Select *, ROW_NUMBER() over (order by ProcessingDate desc) as MonthNumber
		FROM
			(Select distinct ProcessingDate
			FROM [DatabaseName].[dbo].[TableName]
			) TableAlias1
		) TableAlias2
	Where MonthNumber = X) --Substitute X with the number of periods back we want to check
	and Field4 in ('VALUE1','VALUE2','VALUE3')