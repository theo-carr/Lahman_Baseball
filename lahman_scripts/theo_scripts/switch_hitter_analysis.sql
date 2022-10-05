WITH switch_hitters as (
	SELECT playerid, 
		   namefirst, 
		   namelast
	FROM people
	WHERE bats = 'B'
)


SELECT playerid,
	   namefirst,
	   namelast, 
	   SUM(h) as total_hits,
	   SUM(ab) as total_ab
FROM batting INNER JOIN switch_hitters USING(playerid)
GROUP BY playerid, namefirst, namelast