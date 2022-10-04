
WITH multi_lg_tsn_winners as(
	SELECT playerid,
		   al_wins,
		   nl_wins
	FROM (
		SELECT playerid,
			   COUNT(CASE WHEN lgid = 'AL' THEN 'al_win' END) as al_wins,
			   COUNT(CASE WHEN lgid = 'NL' THEN 'nl_win' END) as nl_wins
		FROM awardsmanagers
		WHERE awardid ILIKE 'TSN%'
			  AND lgid <> 'ML'
		GROUP BY playerid
	) as subq
	WHERE al_wins > 0 AND nl_wins > 0
)
SELECT CONCAT(CONCAT(namefirst, ' '),namelast) as namefull,
	   yearid,
	   teamid,
	   managers.lgid
	   awardid
FROM multi_lg_tsn_winners INNER JOIN awardsmanagers USING(playerid)
						  INNER JOIN managers USING(playerid, yearid)
						  INNER JOIN people USING(playerid)
WHERE awardid ILIKE 'TSN%'
ORDER BY namefull


