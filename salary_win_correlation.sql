WITH salary_win as(
	SELECT DISTINCT teamid,
		   yearid,
		   SUM(salary) OVER(PARTITION BY teamid,yearid) as total_salary,
		   teams.w--wins
	FROM salaries INNER JOIN teams USING(teamid,yearid)
	WHERE yearid >= 2000
	ORDER BY yearid,teamid
)
SELECT yearid, CORR(total_salary,w) as r_score
FROM salary_win
GROUP BY yearid