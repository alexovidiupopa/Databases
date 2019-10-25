
--chess clubs
INSERT INTO ChessClub VALUES (1,'The Kings');
INSERT INTO ChessClub VALUES (2,'The Queens');
INSERT INTO ChessClub VALUES (3,'The Rooks');
INSERT INTO ChessClub VALUES (4,'The Knights');
INSERT INTO ChessClub VALUES (5,'The Bishops');
INSERT INTO ChessClub VALUES (6,'The Pawns');
INSERT INTO ChessClub VALUES (7,'The Conquerers');
INSERT INTO ChessClub VALUES (8,'The Rockers');

--titles
INSERT INTO ChessTitle VALUES (1, 'IM');
INSERT INTO ChessTitle VALUES (2, 'GM');
INSERT INTO ChessTitle VALUES (3, 'NM');
INSERT INTO ChessTitle VALUES (4, 'M');

--players
INSERT INTO ChessPlayer VALUES (1,'M.Tal',3,2,1);
INSERT INTO ChessPlayer VALUES (2,'M.Carlsen',3,2,3);
INSERT INTO ChessPlayer VALUES (3,'Agadmator',2,1,4);
INSERT INTO ChessPlayer VALUES (4,'Alex',1,4,8);
INSERT INTO ChessPlayer VALUES (5,'Razvan',10,4,8);
INSERT INTO ChessPlayer VALUES (6,'G.Kasparov',7,4,8);
--tournaments
INSERT INTO Tournament VALUES (1,'Brasov Open');
INSERT INTO Tournament VALUES (2,'Cluj-Napoca Blitz');

--m:n tournaments history
INSERT INTO TournamentParticipantsHistory VALUES (1,1,2);
INSERT INTO TournamentParticipantsHistory VALUES (2,4,1);
INSERT INTO TournamentParticipantsHistory VALUES (3,3,1);
INSERT INTO TournamentParticipantsHistory VALUES(4,1,1);

--tactics
INSERT INTO Tactic VALUES (1,'Italian Game');
INSERT INTO Tactic VALUES (2,'Queens Gambit');
INSERT INTO Tactic VALUES (3,'Berlin Defense');
INSERT INTO Tactic VALUES (4, 'Evans Gambit');

--m:n tactics history
INSERT INTO TacticsHistory VALUES (2,1);
INSERT INTO TacticsHistory VALUES (2,3);
INSERT INTO TacticsHistory VALUES (1,4);

--violate a constraint, so this next one crashes when executed
--INSERT INTO TournamentParticipantsHistory VALUES (3,10,10);

--Standings
INSERT INTO FideStandings VALUES (1,2);
INSERT INTO FideStandings VALUES (2,1);

--Match
INSERT INTO MatchFormat VALUES (1,'Blitz');
INSERT INTO MatchFormat VALUES (2,'Classic');

INSERT INTO Match VALUES (1,1,2,1);
INSERT INTO Match VALUES (2,2,3,2);


-- UPDATES 
UPDATE ChessPlayer 
SET rating = 5
WHERE title_id=2;

UPDATE ChessPlayer 
SET rating = 0
WHERE (title_id = 2 AND player_name = 'M.Tal');

UPDATE ChessPlayer
SET rating = 10
WHERE (title_id = 2 OR player_name = 'M.Carlsen');

UPDATE ChessPlayer 
SET player_name = 'RANDOM'
WHERE NOT rating=10;

UPDATE ChessPlayer 
SET player_name = 'Alex'
WHERE club_id <> 8;

UPDATE ChessPlayer 
SET player_name = 'Hello' 
WHERE club_id>=8;

UPDATE ChessPlayer 
SET player_name = 'Agad'
WHERE club_id < 8;

UPDATE Match 
SET match_type = 1
WHERE match_type > 1;

UPDATE Match 
SET match_type = 2
WHERE match_type <= 2

UPDATE FideStandings 
SET player_id = 4
WHERE rank_id IS NOT NULL;

--DELETES 
INSERT INTO FideStandings VALUES (3,1);

DELETE FROM FideStandings WHERE player_id BETWEEN 4 and 5;
DELETE FROM ChessClub WHERE club_name IN ('The Bishops','The Pawns');
DELETE FROM ChessClub WHERE club_name LIKE '%Q%';

--a. 2 queries with the union operation; use UNION [ALL] and OR;

--get all the player id's that have or haven't played a tournament
SELECT player_id 
FROM ChessPlayer
UNION ALL
SELECT player_id
FROM TournamentParticipantsHistory;

--get all the club id's for the clubs called 'the rockers' or 'the kings'
SELECT cid
FROM ChessClub 
WHERE club_name='The Rockers' OR club_name='The Kings';

--b. 2 queries with the intersection operation; use INTERSECT and IN;

--get the ids of the players who have played in at least a tournament
SELECT player_id 
FROM ChessPlayer
INTERSECT
SELECT player_id
FROM TournamentParticipantsHistory;

--get only the players which belong to the clubs with id 1, 3 or 8
SELECT player_id 
FROM ChessPlayer
WHERE club_id IN (1,3,8);

--c. 2 queries with the difference operation; use EXCEPT and NOT IN;
--get the ids of the players who haven't played in any tournaments
SELECT player_id 
FROM ChessPlayer
EXCEPT
SELECT player_id
FROM TournamentParticipantsHistory;

--get the id of the player who doesn't belong in either chess club with ids 1, 3 or 8
SELECT player_id 
FROM ChessPlayer
WHERE club_id NOT IN (1,3,8);

--d. 4 queries with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN; one query will join at least 3 tables, 
--while another one will join at least two many-to-many relationships;

-- 2 m:n join
SELECT TournamentParticipantsHistory.tourn_id, TacticsHistory.player_id,TacticsHistory.tactic_id 
FROM TournamentParticipantsHistory
RIGHT JOIN TacticsHistory ON TournamentParticipantsHistory.player_id = TacticsHistory.player_id;

--left join
SELECT TournamentParticipantsHistory.tourn_id, TacticsHistory.player_id,TacticsHistory.tactic_id 
FROM TournamentParticipantsHistory
LEFT JOIN TacticsHistory ON TournamentParticipantsHistory.player_id = TacticsHistory.player_id;

--3 tables
SELECT ChessClub.club_name, ChessTitle.title_name, ChessPlayer.player_name
FROM ((ChessPlayer 
INNER JOIN ChessClub ON ChessClub.cid = ChessPlayer.club_id)
INNER JOIN ChessTitle ON ChessTitle.tid = ChessPlayer.title_id);

--full join with top 4
SELECT TOP 4 TournamentParticipantsHistory.tourn_id, TacticsHistory.player_id,TacticsHistory.tactic_id 
FROM TournamentParticipantsHistory
FULL JOIN TacticsHistory ON TournamentParticipantsHistory.player_id = TacticsHistory.player_id;

--e. 2 queries using the IN operator to introduce a subquery in the WHERE clause; in at least one query, the subquery should include a subquery 
--in its own WHERE clause;

--find the name of the chess players who played in the tournament with id 1
SELECT CP.player_name
FROM ChessPlayer CP
WHERE CP.player_id IN 
	(SELECT T.player_id
	FROM TournamentParticipantsHistory T
	WHERE T.tourn_id=1
	)

--find the name of the chess players with rating 1 belonging to the club with id 8 who also played in the tournament with id 1
SELECT CP.player_name
FROM ChessPlayer CP
WHERE CP.player_id IN (
	SELECT CP.player_id
	FROM ChessPlayer CP 
	WHERE CP.rating=1 AND CP.club_id=8 AND CP.player_id IN (
				SELECT T.player_id
				FROM TournamentParticipantsHistory T
				WHERE T.tourn_id=1
				)
	)
--f. 2 queries using the EXISTS operator to introduce a subquery in the WHERE clause;

-- find the name of the tactic(s) played by the player with id 2
SELECT T.tactic_name
FROM Tactic T
WHERE EXISTS ( SELECT *
			   FROM TacticsHistory TH
			   WHERE TH.player_id = 2 AND TH.tactic_id = T.tactic_id
			   )

--find the name+rating of the players who played in the tournament with id 1 or are in club with id 8
SELECT CP.player_name,CP.rating
FROM ChessPlayer CP
WHERE EXISTS ( SELECT *
			   FROM TournamentParticipantsHistory T
			   WHERE T.player_id = CP.player_id AND (T.tourn_id=1 OR CP.club_id=8)
			 )

--g. 2 queries with a subquery in the FROM clause;                             

--players who played in tournament with id 1
SELECT CP.*
FROM ChessPlayer CP INNER JOIN 
	(SELECT * 
	FROM TournamentParticipantsHistory T
	WHERE T.tourn_id=1)  as X
ON CP.player_id=X.player_id


--players who played the tactic with id 1
SELECT CP.*
FROM ChessPlayer CP INNER JOIN
	(SELECT *
	FROM TacticsHistory TH
	WHERE TH.tactic_id=1) as X 
ON CP.player_id = X.player_id

--h. 4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause; 2 of the latter will also have a subquery in the HAVING clause; 
--use the aggregation operators: COUNT, SUM, AVG, MIN, MAX;

--find the rating of the lowest rated player for each chess club
SELECT CP.club_id, MIN(CP.rating) MinRating
FROM ChessPlayer CP 
GROUP BY CP.club_id

--get the players with the biggest number of played tournaments 
SELECT TH.player_id, COUNT(*) NumTournaments
FROM TournamentParticipantsHistory TH
GROUP BY TH.player_id
HAVING COUNT(*)=
	(SELECT MAX(NumTournaments)
	 FROM  
		(SELECT COUNT(*) NumTournaments
		FROM TournamentParticipantsHistory TH
		GROUP BY TH.player_id) t
	)
	
--list all ratings which have at least two players
SELECT CP.rating, COUNT(CP.rating) NumOfPlayersWithRating
FROM ChessPlayer CP
GROUP BY CP.rating 
HAVING COUNT(CP.rating) > 1
ORDER BY CP.rating DESC

--get the ratings which are greater than the average
(SELECT CP.rating
FROM ChessPlayer CP
GROUP BY CP.rating
HAVING CP.rating >
	(SELECT AVG(CP.rating) AvgRating
	FROM ChessPlayer CP)  
	) 
--i. 4 queries using ANY and ALL to introduce a subquery in the WHERE clause; 2 of them should be rewritten with aggregation operators, 
--while the other 2 should also be expressed with [NOT] IN.


--finds all chess players whose rating is greater than any of the players with the name Hello, sorted in reversed alphabetical order
SELECT DISTINCT CP.player_name
FROM ChessPlayer CP
WHERE CP.rating > ANY
	(SELECT CP2.rating
	FROM ChessPlayer CP2
	WHERE CP2.player_name = 'Hello'
	)
ORDER BY CP.player_name DESC

--rewrite with IN+ distinct when it comes to both rating and name + sorted by rating asc
SELECT DISTINCT TOP 2  CP.player_name, CP.rating
FROM ChessPlayer CP
WHERE CP.rating IN
	(SELECT CP2.rating
	FROM ChessPlayer CP2
	WHERE CP2.player_name = 'Hello'
	)
ORDER BY CP.rating

--find the id of all players who have their rating different from all players with the rang of grandmaster(id 1)
SELECT DISTINCT CP.player_name
FROM ChessPlayer CP
WHERE CP.rating <> ALL 
	(SELECT CP2.rating 
	FROM ChessPlayer CP2
	WHERE CP2.title_id=1
	)

--rewrite with not in
SELECT DISTINCT CP.player_name
FROM ChessPlayer CP
WHERE CP.rating NOT IN 
	(SELECT CP2.rating 
	FROM ChessPlayer CP2
	WHERE CP2.title_id=1
	)


--find the players whose rating is greater than any of the players from chess club with id 8
SELECT CP.player_name
FROM ChessPlayer CP
WHERE CP.rating > ANY 
	(SELECT CP2.rating
	FROM ChessPlayer CP2
	WHERE CP2.club_id = 8
	)

--rewrite with aggregation - MIN
SELECT CP.player_name
FROM ChessPlayer CP
WHERE CP.rating > 
	(SELECT MIN(CP2.rating)
	FROM ChessPlayer CP2)

