WITH player_hr_high as ( 
	SELECT DISTINCT playerid,
		   yearid,
		   hr,
		   MAX(hr) OVER(PARTITION BY playerid) as hr_high
	FROM BATTING

	ORDER BY hr_high DESC
)
SELECT namefirst,
	   namelast,
	   hr
FROM player_hr_high INNER JOIN people USING(playerid)
WHERE playerid IN( -- CHECKS TO SEE IF THEY HAVE PLAYED AT LEAST 10 SEASONS
					WITH cr_len as (
						SELECT playerid, 
							   namefirst,
							   namelast,
							   COUNT(DISTINCT yearid) as seasons_played
						FROM batting INNER JOIN people USING(playerid)
						GROUP BY playerid,namefirst,namelast
						ORDER BY seasons_played DESC
					)
					SELECT playerid
					FROM cr_len
					WHERE seasons_played >= 10
)
	AND hr = hr_high
	AND yearid = 2016
	AND hr > 0
ORDER BY hr DESC;
