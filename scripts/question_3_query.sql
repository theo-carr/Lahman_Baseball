--Question 3

SELECT namefirst,
	   namelast,
	   SUM(salary) AS total_salary
FROM people
INNER JOIN salaries USING (playerid)
WHERE playerid IN (SELECT playerid
				   FROM people
				   INNER JOIN collegeplaying USING (playerid)
				   WHERE schoolid ILIKE 'vandy')
GROUP BY namefirst,
		 namelast
ORDER BY total_salary DESC;

--Answer: David Price with $81,851,296

