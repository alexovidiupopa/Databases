USE Chess4

--ALTER TABLE ChessPlayer DROP CONSTRAINT DF__ChessPlay__ratin__4D94879B


--a)Modify the type of a column
GO
CREATE PROCEDURE MAKE1 AS
BEGIN 
	ALTER TABLE ChessPlayer
	ALTER COLUMN rating INT;
END;

EXEC MAKE1;

GO
CREATE PROCEDURE REMAKE1 AS
BEGIN
	ALTER TABLE ChessPlayer
	ALTER COLUMN rating TINYINT;
END;

EXEC REMAKE1;


--b)Add/remove a column

GO
CREATE PROCEDURE MAKE2 AS 
BEGIN 
	ALTER TABLE ChessPlayer
	DROP COLUMN rating;
END;

EXEC MAKE2;

GO 
CREATE PROCEDURE REMAKE2 AS
BEGIN 
	ALTER TABLE ChessPlayer
	ADD rating TINYINT;
END;

EXEC REMAKE2;

--c)add/remove a DEFAULT constraint
GO
CREATE PROCEDURE MAKE3 AS
BEGIN 
	ALTER TABLE ChessPlayer
	ADD CONSTRAINT def_rating DEFAULT 'TBA' FOR rating;
END;

EXEC MAKE3;

GO
CREATE PROCEDURE REMAKE3 AS
BEGIN 
	ALTER TABLE ChessPlayer
	DROP CONSTRAINT def_rating;
END;

EXEC REMAKE3;

--d)add/remove a primary key
GO 
CREATE PROCEDURE MAKE4 AS
BEGIN 
	ALTER TABLE TacticsHistory
	DROP CONSTRAINT PK_TacticsHistory;
END;

EXEC MAKE4;

GO
CREATE PROCEDURE REMAKE4 AS
BEGIN 
	ALTER TABLE TacticsHistory
	ADD CONSTRAINT PK_TacticsHistory PRIMARY KEY NONCLUSTERED (player_id,tactic_id);
END;

EXEC REMAKE4;

--e)add/remove a candidate key
--the name of a tactic is a candidate key since it can't be duplicated
GO
CREATE PROCEDURE MAKE5 AS 
BEGIN 
	ALTER TABLE Tactic
	DROP CONSTRAINT def_name;
	ALTER TABLE Tactic
	DROP COLUMN tactic_name;
END;

EXEC MAKE5;

GO
CREATE PROCEDURE REMAKE5 AS
BEGIN 
	ALTER TABLE Tactic
	ADD tactic_name VARCHAR(30);
	ALTER TABLE Tactic
	ADD CONSTRAINT def_name DEFAULT 'TBA' FOR tactic_name;
END;

EXEC REMAKE5;

--f)add/remove a foreign key
GO
CREATE PROCEDURE MAKE6 AS
BEGIN
	ALTER TABLE TournamentParticipantsHistory
	DROP CONSTRAINT FK_TournamentParticipantsHistory_ChessPlayer;
END;

EXEC MAKE6;

GO
CREATE PROCEDURE REMAKE6 AS
BEGIN 
	ALTER TABLE TournamentParticipantsHistory
	ADD CONSTRAINT FK_TournamentParticipantsHistory_ChessPlayer FOREIGN KEY (player_id) REFERENCES ChessPlayer (player_id);
END;

EXEC REMAKE6;

--g)create/remove a table
GO
CREATE PROCEDURE MAKE7 AS
BEGIN
	DROP TABLE WorldChampions;
END;

EXEC MAKE7;

GO
CREATE PROCEDURE REMAKE7 AS
BEGIN 
	CREATE TABLE WorldChampions(
	worldc_id TINYINT PRIMARY KEY,
	player_id INT REFERENCES ChessPlayer(player_id),
	years TINYINT DEFAULT 'TBA'
	);
END;

EXEC REMAKE7;


--and now we get down to business