WITH teams_total_salary as (
	SELECT DISTINCT teamid,
		   yearid,
		   SUM(salary) OVER(PARTITION BY teamid,yearid) as total_salary,
		   teams.w--wins
	FROM salaries INNER JOIN teams USING(teamid,yearid)
	WHERE yearid >= 2000
	ORDER BY yearid,teamid
)
SELECT teamid,	
	   yearid,
	   total_salary,
	   w,
	   RANK() OVER(ORDER BY total_salary DESC) as salary_rank,
	   RANK() OVER(ORDER BY w DESC) as wins_rank
FROM teams_total_salary
WHERE yearid = 2000
--ORDER BY total_salary DESC
ORDER BY w DESC