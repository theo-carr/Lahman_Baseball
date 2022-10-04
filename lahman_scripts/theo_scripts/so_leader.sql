SELECT 	CONCAT(CONCAT(namefirst,' '),namelast) AS namefull, total_so
FROM people AS p 
INNER JOIN (SELECT playerid, SUM(so) as total_so
			FROM pitching
			INNER JOIN people USING(playerid)
			GROUP BY playerid
			ORDER BY total_so DESC) as so USING(playerid)
ORDER BY total_so DESC;