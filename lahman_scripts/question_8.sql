--top 5 average attendance 2016--
SELECT year,
	   teams.name,
	   park_name,
	   homegames.attendance/homegames.games as avg_attendance
FROM homegames INNER JOIN teams ON homegames.team = teams.teamid AND homegames.year = teams.yearid
			   INNER JOIN parks ON homegames.park = parks.park
WHERE year = 2016 AND games >= 10
ORDER BY avg_attendance DESC
LIMIT 5;

--bottom 5 average attendance 2016--
SELECT year,
	   teams.name,
	   park_name,
	   homegames.attendance/homegames.games as avg_attendance
FROM homegames INNER JOIN teams ON homegames.team = teams.teamid AND homegames.year = teams.yearid
			   INNER JOIN parks ON homegames.park = parks.park
WHERE year = 2016 AND games >= 10
ORDER BY avg_attendance 
LIMIT 5;