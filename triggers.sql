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

-- Create a trigger when price of pc is changed
-- that this price will not be lower than any pc
-- with the same processor speed
USE pc
GO
CREATE TRIGGER EnforcePrice ON pc AFTER INSERT, UPDATE
AS
    IF NOT EXISTS(SELECT * FROM pc p
 	    	  JOIN inserted i ON p.price < i.price AND p.speed = i.speed)
        BEGIN
            RAISERROR('There shouldnt be price lower for this processor speed', 11, 1)
            ROLLBACK
        END
GO

-- Create a trigger that does not allow
-- to have manufacturer that produces both
-- printers and laptops
USE pc
GO
CREATE TRIGGER EnforceManufacturer ON product AFTER INSERT, UPDATE, DELETE
AS
    IF EXISTS(SELECT * FROM product p1
             JOIN product p2 ON p1.maker = p2.maker
             JOIN inserted i ON i.maker = p1.maker
             JOIN deleted d ON d.maker = p1.maker
             WHERE p1.type = 'PC' and p2.type = 'Printer')
        BEGIN
            RAISERROR('One manufacturer can only manufacture PC or Printers not both.', 11, 1)
            ROLLBACK
        END
GO
