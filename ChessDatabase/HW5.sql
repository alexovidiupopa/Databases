CREATE DATABASE hw5

DROP TABLE Ta
CREATE TABLE Ta(
	aid INT NOT NULL IDENTITY (1,1), 
	CONSTRAINT PK_Ta PRIMARY KEY (aid),
	a2 INT UNIQUE,
	additionalField VARCHAR(100)
);
	
DROP TABLE Tb
CREATE TABLE Tb(
	bid INT NOT NULL IDENTITY (1,1), 
	CONSTRAINT PK_Tb PRIMARY KEY (bid),
	b2 INT 
);

DROP TABLE Tc
CREATE TABLE Tc(
	cid INT NOT NULL IDENTITY (1,1),
	CONSTRAINT PK_Tc PRIMARY KEY (cid), 
	aid INT REFERENCES Ta(aid), 
	bid INT REFERENCES Tb(bid)
	);


INSERT INTO Ta VALUES (2,'a'),(30,'b'), (-7,'c'), (178,'d'), (0,'e')
INSERT INTO Tb VALUES (10), (2), (2), (120), (-123)
INSERT INTO Tc VALUES (1,1),(2,2),(3,3),(4,4),(5,5), (5,1), (1,2), (2,3)


SELECT * FROM Tc

--a)
--clustered index scan
SELECT *
FROM  Ta 
WHERE a2 < 0 
ORDER BY aid DESC
--clustered index seek
SELECT * 
FROM Ta 
WHERE aid>0

--nonclustered index scan + key lookup
SELECT *
FROM Ta 
ORDER BY a2

--nonclustered index seek
SELECT aid 
FROM Ta 
WHERE a2 = 2


--b)

GO 
DROP INDEX Idx_NC_b2 ON Tb
GO
--without creating said index, the execution plan is a clustered index scan
--Select estimated subtree cost: 0.0032875
SELECT *
FROM Tb 
WHERE b2 = 2


CREATE NONCLUSTERED INDEX Idx_NC_b2 ON Tb(b2)
--now, the execution plan will show a nonclustered index seek, which would be more efficient
--Select estimated subtree cost: 0.0032842


--c)
--this will use the previously created index and split the cost...
GO
CREATE VIEW cView
AS 
	SELECT *
	FROM Ta a
	INNER JOIN Tb b  ON a.a2=b.b2
	--INNER JOIN Tc c ON a.aid = c.aid

GO
SELECT * FROM cView

