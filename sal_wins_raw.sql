SELECT DISTINCT teamid,
	   yearid,
	   SUM(salary) OVER(PARTITION BY teamid,yearid) as total_salary,
	   teams.w--wins
FROM salaries INNER JOIN teams USING(teamid,yearid)
WHERE yearid >= 2000
ORDER BY yearid,teamid