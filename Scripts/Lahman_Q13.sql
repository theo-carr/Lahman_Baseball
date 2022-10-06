
--Q13
--It is thought that since left-handed pitchers are more rare, 
--causing batters to face them less often, that they are more effective. 
--Investigate this claim and present evidence to either support or dispute this claim. 
--First, determine just how rare left-handed pitchers are compared with right-handed pitchers. 

--A: While on average 10% of people throw left handed, 27% of baseball pitchers throw left-handed. 

SELECT namelast || ', ' || namefirst AS name, throws
FROM people;

SELECT DISTINCT playerid
FROM fielding 
WHERE pos = 'P';

--inner query select statement at from to pull only distint names into the outer query

WITH pitcher_lr AS (SELECT COUNT (CASE WHEN throws = 'R' THEN 'right_handed' END) AS right_handed,
					   COUNT (CASE WHEN throws = 'L' THEN 'left_handed' END) as left_handed,
					   COUNT(throws) AS total 
				FROM (SELECT DISTINCT playerid FROM fielding WHERE pos = 'P') as dist_players
				INNER JOIN  people
				USING (playerid))
SELECT *, (left_handed/total::float) * 100 AS percent_left
FROM pitcher_lr;


--Are left-handed pitchers more likely to win the Cy Young Award? 
--A: 33% of Cy Young Awards are held by lefties, this is a slightly higher representation
-- of lefties out of the 27% of total pitchers throwing left handed. 

SELECT *
FROM awardsplayers
WHERE awardid ILIKE 'CY%';




WITH count_of AS (WITH cy_winners AS (WITH pitchers AS (SELECT playerid, throws
													FROM (SELECT DISTINCT playerid FROM fielding WHERE pos = 'P') AS dist_players
													INNER JOIN people
													USING (playerid))
									SELECT pitchers.playerid, awardid, yearid, lgid, throws
									FROM pitchers
									INNER JOIN awardsplayers
									USING (playerid)
									WHERE awardid = 'Cy Young Award')
					SELECT COUNT (CASE WHEN throws = 'R' THEN 'right_handed' END) AS right_handed,
						   COUNT (CASE WHEN throws = 'L' THEN 'left_handed' END) AS left_handed, 
						   COUNT (throws) AS total
					FROM cy_winners)
SELECT *, (left_handed/total::float) * 100 AS percent_left_cy
FROM count_of;

--Are they more likely to make it into the hall of fame?
--A: 23% of hall of fame inductees are lefties, this is a slightly lower representation
-- of lefties out of the 27% of total pitchers throwing left handed. 

SELECT playerid, yearid, inducted, category
FROM halloffame
WHERE inducted = 'Y'
ORDER BY playerid;

WITH count_of_w AS( 
WITH hall_of_fame_w AS (WITH pitchers AS (SELECT playerid, throws
										FROM (SELECT DISTINCT playerid FROM fielding WHERE pos = 'P') AS dist_players
										INNER JOIN people
										USING (playerid))
						SELECT pitchers.playerid, yearid, category, throws
						FROM pitchers
						INNER JOIN halloffame
						USING (playerid)
						WHERE inducted = 'Y')
SELECT COUNT (CASE WHEN throws = 'R' THEN 'right_handed' END) AS right_handed,
	   COUNT (CASE WHEN throws = 'L' THEN 'left_handed' END) AS left_handed, 
	   COUNT (throws) AS total
FROM hall_of_fame_w)
SELECT *, (left_handed/total::float) * 100 AS percent_left_hof
FROM count_of_w;

--strikeouts from r vs l


--using pitching instead of teams...still too high needed to join pitching on playerid and yearid
-- 27% of strikeouts are from lefthanded pitchers, which is the expected representation, looking at it this way, 
--there are no advantages to striking out a batter if you are a lefthanded pitcher 

WITH total_so AS (SELECT dist_players.playerid, throws, SUM(so) AS sum_so
				FROM (SELECT DISTINCT playerid, yearid FROM fielding WHERE pos = 'P') AS dist_players
				INNER JOIN people
				USING (playerid)
				INNER JOIN pitching 
				USING (playerid, yearid)
				GROUP BY dist_players.playerid, throws
				ORDER BY sum_so DESC)
SELECT throws, SUM(sum_so) AS sum_so_by_lr
FROM total_so
GROUP BY throws;
	


SELECT * FROM pitching
ORDER BY playerid;