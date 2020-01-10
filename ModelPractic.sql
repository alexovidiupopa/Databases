
USE modelPractic
GO

--1)
DROP TABLE IF EXISTS RoutesStations
DROP TABLE IF EXISTS Stations 
DROP TABLE IF EXISTS Routes 
DROP TABLE IF EXISTS Trains 
DROP TABLE IF EXISTS TrainTypes

GO

CREATE TABLE TrainTypes(
	ttid INT PRIMARY KEY IDENTITY(1,1),
	description VARCHAR(200)
);

CREATE TABLE Trains(
	tid INT PRIMARY KEY IDENTITY(1,1), 
	name VARCHAR(100),
	ttid INT REFERENCES TrainTypes(ttid)
);

CREATE TABLE Stations(
	sid INT PRIMARY KEY IDENTITY(1,1),
	sname VARCHAR(100) UNIQUE
);

CREATE TABLE Routes(
	rid INT PRIMARY KEY IDENTITY(1,1),
	rname VARCHAR(100) UNIQUE, 
	tid INT REFERENCES Trains(tid)
);

CREATE TABLE RoutesStations(
	rid INT REFERENCES Routes(rid),
	sid INT REFERENCES Stations(sid),
	Arrival TIME, 
	Departure TIME,
	PRIMARY KEY(rid,sid)
);
GO

--2)
CREATE OR ALTER PROC uspStationOnRoute 
	@sname VARCHAR(100), @rname VARCHAR(100), @a TIME, @d TIME
AS 
	DECLARE @SID INT = (SELECT sid FROM Stations WHERE sname = @sname), 
			@RID INT = (SELECT rid FROM Routes WHERE rname=@rname)
	IF @SID IS NULL OR @RID IS NULL
	BEGIN
		RAISERROR('no such station/error',16,1)
		RETURN -1
	END
	IF EXISTS(SELECT * FROM RoutesStations WHERE sid = @SID AND rid=@RID)
		UPDATE RoutesStations 
		SET Arrival=@a, Departure=@d 
		WHERE sid = @sid AND rid = @rid 
	ELSE 
		INSERT RoutesStations VALUES (@rid, @sid, @a, @d)
GO

INSERT TrainTypes VALUES ('interregio'),('regio')
INSERT Trains VALUES ('t1', 1),('t2', 1), ('t3',1)
INSERT Routes  VALUES ('r1',1 ),('r2',2) ,('r3',3)
INSERT Stations VALUES ('s1'),('s2'),('s3')

SELECT * FROM TrainTypes
SELECT * FROM Trains
SELECT * FROM Routes
SELECT * FROM Stations
GO

EXEC uspStationOnRoute 's1','r1','4:00','4:10'
EXEC uspStationOnRoute 's2','r1','5:00','5:10'
EXEC uspStationOnRoute 's3','r1','4:40','4:50'
EXEC uspStationOnRoute 's3','r2','4:40','4:50'

SELECT * FROM RoutesStations
GO

--3)
CREATE OR ALTER VIEW vRoutesWithAllStations 
AS 
	SELECT R.rname
	FROM Routes R 
	WHERE NOT EXISTS 
		(SELECT S.sid 
		FROM Stations S 
		EXCEPT 
		SELECT Rs.sid 
		FROM RoutesStations Rs 
		WHERE Rs.rid = R.rid)
GO 

SELECT * FROM vRoutesWithAllStations
GO

--4)
CREATE OR ALTER FUNCTION ufFilterStations(@R INT)
RETURNS TABLE 
RETURN  SELECT S.sname
	FROM Stations S 
	WHERE S.sid IN 
	(SELECT Rs.sid
	FROM RoutesStations Rs 
	GROUP BY Rs.sid
	HAVING COUNT(*)>=@R)

GO

SELECT * FROM ufFilterStations(1)
GO