WITH cr_len as (
	SELECT playerid, 
		   namefirst,
		   namelast,
		   COUNT(DISTINCT yearid) as seasons_played
	FROM batting INNER JOIN people USING(playerid)
	GROUP BY playerid,namefirst,namelast
	ORDER BY seasons_played DESC
)
SELECT playerid, 
	   seasons_played
FROM cr_len
WHERE seasons_played >= 10 
