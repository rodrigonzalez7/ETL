/****** Script for SelectTopNRows command from SSMS  ******/
--Select Duplicates
WITH DuplicatesTable as
(
Select *, --ROW_NUMBER is used to enumerate how many times the register appears
	ROW_NUMBER() over (partition by Field1,Field2 order by Field1, Field2) as NumRegistersRep
FROM [DatabaseName].[dbo].[TableName]
Where Field1+'-'+Field2 in (	--Only the registers with repetitions are selected
	Select ID
	FROM
		(--This subquery takes the registers that appear more than once
		SELECT [Field1]
			  ,[Field2], --
			  Field1+'-'+Field2 as Id,
			  Count(*) as Repetitions
		FROM [DatabaseName].[dbo].[TableName]
		Group by Field1, Field2
		Having count(*) > 1 --Here is indicated that we need tge registers that appear more than once
		) A
	)
)

Select *
From DuplicatesTable

--Delete duplicates
WITH DuplicatesTable as
(
Select *, --
	ROW_NUMBER() over (partition by Referencia,FecProceso order by Referencia, FecProceso) as NumRegistroRep
FROM [DatabaseName].[dbo].[TableName]
Where Field1+'-'+Field2 in (
	Select ID
	FROM
		(
		SELECT Field1
			  ,[Field2], --EN ESTE CASO LOS CAMPOS SON NIU Y FEC PROCESO
			  Field1+'-'+Field2 as Id,
			  Count(*) as Repetitions
		FROM [DatabaseName].[dbo].[TableName]
		Group by Field1, Field2
		Having count(*) > 1 --ACÁ SE INDICA QUE SON LOS QUE APAREZCAN MÁS DE UNA VEZ
		) A
	)
)
DELETE From DuplicatesTable
WHERE Repetitions > 1