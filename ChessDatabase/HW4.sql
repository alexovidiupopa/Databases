
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

CREATE TABLE Aux(
	id INT NOT NULL, 
	CONSTRAINT PK_Aux PRIMARY KEY (id)
);

INSERT INTO Aux VALUES (1),(2),(3);
GO 
CREATE VIEW ViewPlayer 
AS 
	SELECT * 
	FROM Player 
GO 

CREATE OR ALTER VIEW ViewGame 
AS 
	SELECT Game.id
	FROM Game INNER JOIN Transactions ON Game.id = Transactions.buyer_id
GO

CREATE OR ALTER VIEW ViewTransactions
AS 
	SELECT Transactions.buyer_id
	FROM Transactions INNER JOIN Aux ON Aux.id = Transactions.buyer_id
	GROUP BY buyer_id
	
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

SELECT * FROM TestViews

--(testId, tableId, NoOfRows, Position) 
-- note to self: position denotes the order in which they will be executed
--				no of rows= how many to be inserted
DELETE FROM TestTables 
INSERT INTO TestTables VALUES (2, 7, 100, 1)
INSERT INTO TestTables VALUES (4, 8, 100, 2)
INSERT INTO TestTables VALUES (6, 9, 100, 3)

SELECT * FROM TestTables

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
	DELETE FROM Player WHERE pid>1;

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
	DELETE FROM Game;

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
	DELETE FROM Transactions;

SELECT * FROM Views


GO
CREATE OR ALTER PROC TestRunViewsProc
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
	INSERT INTO TestRuns VALUES ('test_view', @start1, @end1)
    INSERT INTO TestRunViews VALUES (@@IDENTITY, 1, @start1, @end1);

	SET @start2 = GETDATE();
	PRINT ('executing select * from game')
	EXEC ('SELECT * FROM ViewGame');
	SET @end2 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_view2', @start2, @end2)
    INSERT INTO TestRunViews VALUES (@@IDENTITY, 2, @start2, @end2);


	SET @start3 = GETDATE();
	PRINT ('executing select * from transactions')
	EXEC ('SELECT * FROM ViewTransactions');
	SET @end3 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_view3', @start3, @end3)
    INSERT INTO TestRunViews VALUES (@@IDENTITY, 3, @start3, @end3);

GO
CREATE OR ALTER PROC TestRunTablesProc
AS 
	DECLARE @start1 DATETIME;
	DECLARE @start2 DATETIME;
	DECLARE @start3 DATETIME;
	DECLARE @start4 DATETIME;
	DECLARE @start5 DATETIME;
	DECLARE @start6 DATETIME;
	DECLARE @end1 DATETIME;
	DECLARE @end2 DATETIME;
	DECLARE @end3 DATETIME;
	DECLARE @end4 DATETIME;
	DECLARE @end5 DATETIME;
	DECLARE @end6 DATETIME;


	SET @start2 = GETDATE();
	PRINT('deleting data from Player')
	EXEC deletePlayer;
	SET @end2 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_delete_player',@start2, @end2);
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 7, @start2, @end2);

	SET @start1 = GETDATE();
	PRINT('inserting data into Player')
	EXEC insertPlayer;
	SET @end1 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_insert_player',@start1, @end1);
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 7, @start1, @end1);

	SET @start4 = GETDATE();
	PRINT('deleting data from Game')
	EXEC deleteGame;
	SET @end4 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_delete_game',@start4, @end4);
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 8, @start4, @end4);

	SET @start3 = GETDATE();
	PRINT('inserting data into Game')
	EXEC insertGame;
	SET @end3 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_insert_game',@start3, @end3);
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 8, @start3, @end3);

	SET @start6 = GETDATE();
	PRINT('deleting data from Player')
	EXEC deleteTransactions;
	SET @end6 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_delete_transactions',@start6, @end6);
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 9, @start6, @end6);

	SET @start5 = GETDATE();
	PRINT('inserting data into Player')
	EXEC insertTransactions;
	SET @end5 = GETDATE();
	INSERT INTO TestRuns VALUES ('test_insert_transactions',@start5, @end5);
	INSERT INTO TestRunTables VALUES (@@IDENTITY, 9, @start5, @end5);

	


GO 
EXEC TestRunTablesProc;
EXEC TestRunViewsProc;

SELECT * FROM TestRuns
SELECT * FROM TestRunViews
SELECT * FROM TestRunTables

DELETE FROM Game 
--DELETE FROM Player
DELETE FROM Transactions
--INSERT INTO Player VALUES (1)

DELETE FROM TestTables 
INSERT INTO TestTables VALUES (2, 7, 100, 1)
INSERT INTO TestTables VALUES (4, 8, 100, 2)
INSERT INTO TestTables VALUES (6, 9, 100, 3)

DELETE FROM TestRunViews
DELETE FROM TestRunTables
DELETE FROM TestRuns

SELECT * FROM Game