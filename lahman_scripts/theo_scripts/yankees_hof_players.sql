SELECT *
FROM 
		(SELECT DISTINCT playerid, namefirst, namelast, teamid,
			CASE WHEN playerid IN(SELECT playerid FROM halloffame WHERE inducted = 'Y') THEN 'YES'
				ELSE 'NO' END AS hall_of_fame
					FROM people 
						INNER JOIN appearances USING(playerid)
							WHERE playerid IN (SELECT playerid FROM appearances)
								AND teamid ILIKE 'nya'
									ORDER BY hall_of_fame DESC) AS nya_hof
WHERE hall_of_fame = 'YES'
