--Question 2

SELECT namefirst,
	   namelast,
	   name,
	   g_all
FROM people
INNER JOIN appearances USING (playerid)
INNER JOIN teams USING (yearid,teamid)
WHERE height = (SELECT MIN(height) FROM people);

--Answer: Eddie Gaedel played for St. Louis Browns
--and played 1 game.

