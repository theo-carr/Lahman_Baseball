--Lahman Baseball Project
SELECT yearid, namefirst || ' ' || namelast AS name, salary
FROM salaries
INNER JOIN people
USING (playerid)
ORDER BY salary DESC;

--Q1 What range of years for baseball games played does the provided database cover? A: 1871-2016
SELECT MIN(yearid), MAX(yearid)
FROM teams;

-- 5-7
--*Q5 Find the average number of strikeouts per game by decade since 1920. Round the numbers you 
--report to 2 decimal places. Do the same for home runs per game. Do you see any trends?  Strikeouts
--and home runs are increasing
--strike outs 
WITH decade_labeled_table as (
	SELECT teamid, 
		   yearid,
		   soa, 
		   g,
		   CASE WHEN yearid > 1920 AND yearid < 1931 THEN '1920s'
				WHEN yearid > 1930 AND yearid < 1941 THEN '1930s'
				WHEN yearid > 1940 AND yearid < 1951 THEN '1940s'
				WHEN yearid > 1950 AND yearid < 1961 THEN '1950s'
				WHEN yearid > 1960 AND yearid < 1971  THEN '1960s'
				WHEN yearid > 1970 AND yearid < 1981 THEN '1970s'
				WHEN yearid > 1980 AND yearid < 1991 THEN '1980s'
				WHEN yearid > 1990 AND yearid < 2001 THEN '1990s'
				WHEN yearid > 2000 AND yearid < 2011 THEN '2000s'
				WHEN yearid > 2010 THEN '2010s' 
				END AS decade
	FROM teams
)
SELECT decade, 
	   ROUND((total_soa::numeric/total_games::numeric),2) as avg_so_per_game
FROM(
	SELECT decade,
		   SUM(soa) as total_soa,
		   SUM(g) as total_games
	FROM decade_labeled_table
	WHERE decade IS NOT NULL
	GROUP BY decade
) as decade_labeled_sums	 
ORDER BY decade;

--homeruns

WITH decade_labeled_table as (
	SELECT teamid, 
		   yearid,
		   hr, 
		   g,
		   CASE WHEN yearid > 1920 AND yearid < 1931 THEN '1920s'
				WHEN yearid > 1930 AND yearid < 1941 THEN '1930s'
				WHEN yearid > 1940 AND yearid < 1951 THEN '1940s'
				WHEN yearid > 1950 AND yearid < 1961 THEN '1950s'
				WHEN yearid > 1960  AND yearid < 1971  THEN '1960s'
				WHEN yearid > 1970  AND yearid < 1981 THEN '1970s'
				WHEN yearid > 1980 AND yearid < 1991 THEN '1980s'
				WHEN yearid > 1990 AND yearid < 2001 THEN '1990s'
				WHEN yearid > 2000 AND yearid < 2011 THEN '2000s'
				WHEN yearid > 2010 THEN '2010s' 
				END AS decade
	FROM teams
)
SELECT decade, 
	   ROUND((total_soa::numeric/total_games::numeric),2) as avg_hr_per_game
FROM(
	SELECT decade,
		   SUM(hr) as total_soa,
		   SUM(g) as total_games
	FROM decade_labeled_table
	WHERE decade IS NOT NULL
	GROUP BY decade
) as decade_labeled_sums	 
ORDER BY decade;

--Q6 Find the player who had the most success stealing bases in 2016, 
--where __success__ is measured as the percentage of stolen base attempts which are successful. 
--(A stolen base attempt results either in a stolen base or being caught stealing.) 
--Consider only players who attempted _at least_ 20 stolen bases.
--A: Chris Owings

WITH steal_attempts AS (SELECT namelast || ', ' || namefirst AS name,playerid, sb, cs, sb + cs AS total_attempts
					FROM batting
					INNER JOIN people
					USING (playerid)
					WHERE sb + cs >= 20
					   AND yearid = '2016')
SELECT name, cs,sb, total_attempts, (sb / total_attempts::float) * 100 AS successful_steals
FROM steal_attempts
ORDER BY successful_steals DESC;

--Q7 From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? A: 116

--What is the smallest number of wins for a team that did win the world series? A: 63

--Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. 
--Then redo your query, excluding the problem year
--there was a strike in 1981? do i just get rid of that year (1981)? That changes the answer to 83 instead

-- How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?
--12 times in 46 years, 26% of the time?



WITH wins_no_ws AS (SELECT yearid,teamid, w, wswin
					FROM teams
					WHERE yearid BETWEEN 1970 and 2016
					AND wswin = 'N'
					ORDER BY w DESC)
SELECT MAX(w)
FROM wins_no_ws;

----

WITH wins_ws AS (SELECT yearid,teamid, w, wswin
				 FROM teams
				 WHERE yearid BETWEEN 1970 and 2016
				  --AND yearid <> 1981
				  AND wswin = 'Y'
				  ORDER BY w)
SELECT MIN(w)
FROM wins_ws;

--
WITH name_team AS (
			WITH ws_teams AS (SELECT yearid,teamid, w, wswin
								FROM teams
								WHERE yearid BETWEEN 1970 and 2016
								ORDER BY yearid DESC)
			SELECT yearid, teamid, wswin, w, MAX(w) OVER (PARTITION BY yearid) as top_wins
			FROM ws_teams
			ORDER BY yearid)
SELECT * 
from name_team
WHERE wswin = 'Y' 
AND w = top_wins


-----other 	questions

--q2Find the name and height of the shortest player in the database. 
--How many games did he play in? What is the name of the team for which he played?

SELECT playerid, namefirst || ' ' || namelast AS name, height
FROM people
ORDER BY height;