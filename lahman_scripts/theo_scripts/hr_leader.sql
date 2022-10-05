WITH team_names AS 
	(SELECT teamid, name,yearid
	 FROM teams)

SELECT people.namefirst, people.namelast, batting.yearid, batting.hr, team_names.name
FROM batting 
	INNER JOIN team_names USING(teamid,yearid)
	INNER JOIN people USING(playerid)
	
	
ORDER BY hr DESC;