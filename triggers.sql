-- Create trigger for table movies.MovieExec that does not 
-- allow average movies.MovieExec.Networth to be less than 500 000
-- from any kind of changes

USE movies
GO
CREATE TRIGGER EnforceNetworth ON MOVIEEXEC AFTER INSERT, UPDATE, DELETE
AS
	IF (SELECT AVG(Networth) FROM (SELECT * FROM MOVIEEXEC 
								  UNION ALL SELECT * FROM inserted
								  UNION ALL SELECT * FROM deleted) u) > 500000
		BEGIN
			RAISERROR('Average networth of movie executives should be below 500 000', 11, 1)
			ROLLBACK
		END
GO
