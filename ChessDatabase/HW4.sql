
USE Tests 

--DROP TABLE Student
CREATE TABLE Player(
	pid INT NOT NULL,
	CONSTRAINT PK_Player PRIMARY KEY(pid)
);

CREATE TABLE Game(
	id INT NOT NULL,
	CONSTRAINT PK_Game PRIMARY KEY(id),
	player_id INT REFERENCES Player(pid)
);

CREATE TABLE Transactions(
	buyer_id INT NOT NULL,
	obj_id INT NOT NULL,
	CONSTRAINT PK_Transactions PRIMARY KEY (buyer_id, obj_id)
);


GO 
CREATE VIEW ViewPlayer 
AS 
	SELECT * 
	FROM Player 
GO 

CREATE VIEW ViewGame 
AS 
	SELECT *
	FROM Game 
GO

CREATE VIEW ViewTransactions
AS 
	SELECT *
	FROM Transactions
GO


DELETE FROM Tables
INSERT INTO Tables VALUES('Player'),('Game'),('Transactions')

DELETE FROM Views 
INSERT INTO Views VALUES ('viewPlayer'),('viewGame'),('viewTransactions')

DELETE FROM Tests 
INSERT INTO Tests VALUES('selectView'),('insertPlayer'),('deletePlayer'),('insertGame'),('deleteGame'),('insertTransactions'),('deleteTransactions') 

SELECT * FROM Tests
SELECT * FROM Tables 
SELECT * FROM Views

DELETE FROM TestViews
INSERT INTO TestViews VALUES (1,1)
INSERT INTO TestViews VALUES (1,2)
INSERT INTO TestViews VALUES (1,3)


--(testId, tableId, NoOfRows, Position) 
-- note to self: position denotes the order in which they will be executed
--				no of rows= how many to be inserted
DELETE FROM TestTables 
INSERT INTO TestTables VALUES (2, 7, 100, 1)
INSERT INTO TestTables VALUES (4, 8, 100, 2)
INSERT INTO TestTables VALUES (6, 9, 100, 3)

SELECT * FROM TestTables

DELETE FROM TestRunViews
DELETE FROM TestRunTables
DELETE FROM TestRuns



INSERT INTO Player VALUES (1)

GO
CREATE OR ALTER PROC insertPlayer 
AS 
	DECLARE @crt INT = 1
	DECLARE @rows INT
	SELECT @rows = NoOfRows FROM TestTables WHERE TestId = 2
	--PRINT (@rows)
	WHILE @crt <= @rows 
	BEGIN 
		INSERT INTO Player VALUES (@crt + 1)
		SET @crt = @crt + 1 
	END 

GO 
CREATE OR ALTER PROC deletePlayer 
AS 
	DELETE FROM Player WHERE pid>1

GO 
CREATE OR ALTER PROC insertGame
AS 
	DECLARE @crt INT = 1
	DECLARE @rows INT
	SELECT @rows = NoOfRows FROM TestTables WHERE TestId = 4
	WHILE @crt <= @rows 
	BEGIN 
		INSERT INTO Game VALUES (@crt,1)
		SET @crt = @crt + 1 
	END 

GO 
CREATE OR ALTER PROC deleteGame 
AS 
	DELETE FROM Game

GO
CREATE OR ALTER PROC insertTransactions
AS 
	DECLARE @crt INT = 1
	DECLARE @rows INT
	SELECT @rows = NoOfRows FROM TestTables WHERE TestId = 6
	--PRINT (@rows)
	WHILE @crt <= @rows 
	BEGIN 
		INSERT INTO Transactions VALUES (@crt,@crt)
		SET @crt = @crt + 1 
	END 

GO 
CREATE OR ALTER PROC deleteTransactions 
AS 
	DELETE FROM Transactions

SELECT * FROM Views

GO
CREATE OR ALTER PROC TestRunViews 
AS 
	DECLARE @start1 DATETIME;
	DECLARE @start2 DATETIME;
	DECLARE @start3 DATETIME;
	DECLARE @end1 DATETIME;
	DECLARE @end2 DATETIME;
	DECLARE @end3 DATETIME;
	
	SET @start1 = GETDATE();
	PRINT ('executing select * from player')
	EXEC ('SELECT * FROM ViewPlayer');
	SET @end1 = GETDATE();
	

	SET @start2 = GETDATE();
	PRINT ('executing select * from game')
	EXEC ('SELECT * FROM ViewGame');
	SET @end2 = GETDATE();
	

	SET @start3 = GETDATE();
	PRINT ('executing select * from transactions')
	EXEC ('SELECT * FROM ViewTransactions');
	SET @end3 = GETDATE();
	