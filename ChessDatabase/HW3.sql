USE Chess4

--start version is version 0

--version 1
--a)Modify the type of a column
GO
CREATE OR ALTER PROCEDURE MAKE1 AS
BEGIN 
	ALTER TABLE WorldChampions
	ALTER COLUMN years INT;
END;

--EXEC MAKE1;

GO
CREATE OR ALTER PROCEDURE REMAKE1 AS
BEGIN
	ALTER TABLE WorldChampions
	ALTER COLUMN years TINYINT;
END;

--EXEC REMAKE1;

--version 2
--b)Add/remove a column

GO
CREATE OR ALTER PROCEDURE MAKE2 AS 
BEGIN 
	ALTER TABLE ChessPlayer
	DROP COLUMN rating;
END;

--EXEC MAKE2;

GO 
CREATE OR ALTER PROCEDURE REMAKE2 AS
BEGIN 
	ALTER TABLE ChessPlayer
	ADD rating TINYINT;
END;

--EXEC REMAKE2;

--version 3
--c)add/remove a DEFAULT constraint
GO
CREATE OR ALTER PROCEDURE MAKE3 AS
BEGIN
	--ALTER TABLE ChessPlayer DROP CONSTRAINT def_rating
	ALTER TABLE Tactic
	ADD CONSTRAINT def_name DEFAULT 'TBA' FOR tactic_name;
END;

--EXEC MAKE3;

GO
CREATE OR ALTER PROCEDURE REMAKE3 AS
BEGIN 
	ALTER TABLE Tactic
	DROP CONSTRAINT def_name;
END;

--EXEC REMAKE3;

--version 4
--d)add/remove a primary key
GO 
CREATE OR ALTER PROCEDURE MAKE4 AS
BEGIN 
	ALTER TABLE TacticsHistory
	DROP CONSTRAINT PK_TacticsHistory;
END;

--EXEC MAKE4;

GO
CREATE OR ALTER PROCEDURE REMAKE4 AS
BEGIN 
	ALTER TABLE TacticsHistory
	ADD CONSTRAINT PK_TacticsHistory PRIMARY KEY NONCLUSTERED (player_id,tactic_id);
END;

--EXEC REMAKE4;

--version 5
--e)add/remove a candidate key
--the name of a tactic is a candidate key since it can't be duplicated
GO
CREATE OR ALTER PROCEDURE MAKE5 AS 
BEGIN 
	ALTER TABLE Tactic
	ADD CONSTRAINT Unique_Tactic_id_name UNIQUE (tactic_id,tactic_name)
END;

--EXEC MAKE5;

GO
CREATE OR ALTER PROCEDURE REMAKE5 AS
BEGIN 
	ALTER TABLE Tactic
	DROP CONSTRAINT Unique_Tactic_id_name
END;

--EXEC REMAKE5;

--version 6
--f)add/remove a foreign key
GO
CREATE OR ALTER PROCEDURE MAKE6 AS
BEGIN
	ALTER TABLE TournamentParticipantsHistory
	DROP CONSTRAINT FK_TournamentParticipantsHistory_ChessPlayer;
END;

--EXEC MAKE6;

GO
CREATE OR ALTER PROCEDURE REMAKE6 AS
BEGIN 
	ALTER TABLE TournamentParticipantsHistory
	ADD CONSTRAINT FK_TournamentParticipantsHistory_ChessPlayer FOREIGN KEY (player_id) REFERENCES ChessPlayer (player_id);
END;

--EXEC REMAKE6;

--version 7
--g)create/remove a table
GO
CREATE OR ALTER PROCEDURE MAKE7 AS
BEGIN
	DROP TABLE IF EXISTS WorldChampions;
END;

--EXEC MAKE7;

GO
CREATE OR ALTER PROCEDURE REMAKE7 AS
BEGIN 
	CREATE TABLE WorldChampions(
	worldc_id TINYINT PRIMARY KEY,
	player_id INT REFERENCES ChessPlayer(player_id),
	years TINYINT 
	);
END;

--EXEC REMAKE7;


--and now we get down to business

--create the database version table
DROP TABLE IF EXISTS DatabaseVersion
CREATE TABLE DatabaseVersion
	(
		id INT IDENTITY (1,1) PRIMARY KEY,
		crt_version INT
	);

--current version is #0
--INSERT INTO DatabaseVersion VALUES (0);
--INSERT INTO DatabaseVersion VALUES (7);

GO
CREATE OR ALTER PROCEDURE goToVersion 
	@version INT AS
BEGIN
	
	DECLARE @crtVersion INT
	SET @crtVersion = (SELECT D.crt_version 
					   FROM DatabaseVersion D)
	--print(@crtVersion)
	DECLARE @procedure VARCHAR(50)

	IF @version<0 OR @version>7 --check for wrong input version 
		BEGIN 
			PRINT 'Version must be in [0,7]'
			RETURN
		END
	ELSE 
		BEGIN
			IF @version>@crtVersion 
			BEGIN
				WHILE @version>@crtVersion
				BEGIN
					SET @crtVersion = @crtVersion+1
					SET @procedure = 'MAKE' + CAST(@crtVersion AS VARCHAR(5))
					EXEC @procedure
				END
			END
			ELSE 
			BEGIN
				WHILE @version<@crtVersion 
				BEGIN
					IF @crtVersion!=0 
					BEGIN
						SET @procedure='REMAKE'+CAST(@crtVersion AS VARCHAR(5))
						EXEC @procedure
					END
					SET @crtVersion=@crtVersion-1
				END
			END
			UPDATE DatabaseVersion SET crt_version = @version;
			RETURN
		END	
END;

EXEC goToVersion 2;

SELECT * FROM DatabaseVersion