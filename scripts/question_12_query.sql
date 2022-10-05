/*Question 12a (Open-Ended)

Does there appear to be any correlation between attendance at home games and number of wins?
*/


WITH win_perc as  (SELECT yearid,name,ROUND(w::numeric/g::numeric*100,2) as win_percent,attendance
					  FROM teams
					  WHERE attendance IS NOT NULL
					  AND yearid>=2000
					  ORDER BY win_percent DESC)

/*WITH avg_attendance AS (SELECT ROUND(AVG(attendance),2) AS avg_attend
						FROM teams
						WHERE yearid>=2000)

SELECT ROUND(AVG(attendance),2)
FROM teams
WHERE yearid>=2000;
*/
SELECT yearid,
	   COUNT(name) as total_teams,
	   ROUND(AVG(win_percent),2) AS avg_win_percent_teams,
	   ROUND(AVG(attendance),2) AS avg_a_teams
FROM win_perc
WHERE attendance>(SELECT ROUND(AVG(attendance),2) AS avg_attend
				  FROM teams
				  WHERE yearid>=2000)
AND win_percent>(SELECT ROUND(AVG(win_percent),2)
			FROM win_perc)
GROUP BY yearid
ORDER BY yearid DESC;

/*SINCE 2000, AT LEAST 9 TEAMS EACH SEASON HAVE
  POSTED A WIN PERCENTAGE AND ATTENDANCE NUMBERS
  ABOVE THE LEAGUE AVERAGE.
*/

--Correlation function:

WITH win_percentage as (SELECT *,ROUND(w::numeric/g::numeric*100,2) AS win_percent
					   FROM teams
					   WHERE attendance IS NOT NULL)
					   
SELECT DISTINCT yearid,
	   CORR(win_percent,attendance::numeric)
	   OVER(PARTITION BY yearid) AS corr_win_attend
FROM win_percentage
WHERE yearid>='2000'
ORDER BY corr_win_attend DESC;

/*SINCE 2000, OVER HALF OF THE YEARS SAW A POSITIVE CORRELATION
BETWEEN WIN PERCENTAGE AND ATTENDANCE
*/


--WORK ON MORE. Trying to count the years with correlation>0.5

					   





/*Question 12b-

Do teams that win the world series see a boost in attendance the following year? 
PLAYOFFS IN GENERAL IS DOWN BELOW
*/


SELECT yearid,
	   name,
	   wswin,
	   attendance
FROM teams
WHERE yearid>=2000
AND name IN (SELECT name
			FROM teams
			WHERE wswin='Y'
			AND yearid>=2000)
ORDER BY name,
		 yearid;
		 
		 
--self-join

--INCREASED ATTENDANCE TABLE FOR ALL TEAMS WHO WON WORLD SERIES

WITH ws_teams as (SELECT yearid,
				   name,
				   wswin,
				   attendance
					FROM teams
					WHERE name IN (SELECT name
								FROM teams
								WHERE wswin='Y')
					ORDER BY name,
							 yearid)
							 
SELECT *,
	   CASE WHEN ws1.attendance<ws2.attendance THEN 'increased'
			ELSE '' END AS increased_attendance
FROM ws_teams as ws1
INNER JOIN ws_teams as ws2 USING (name)
WHERE ws1.wswin='Y'
	AND ws2.yearid=ws1.yearid+1
	AND ws1.attendance IS NOT NULL
	AND ws2.attendance IS NOT NULL
ORDER BY ws1.yearid;

--THE TABLE WITH INCREASED ATTENDANCE THE YEAR AFTER WINNING WORLD SERIES


--THE COUNT OF INCREASED ATTENDANCE (DOWN BELOW)

WITH ws_teams as (SELECT yearid,
					     name,
					     wswin,
					     attendance
				  FROM teams
				  WHERE name IN (SELECT name
								 FROM teams
								 WHERE wswin='Y')
				  ORDER BY name,
						   yearid)
							 
SELECT COUNT(increased_attendance) AS total_increased_attend
FROM (SELECT *,
			CASE WHEN ws1.attendance<ws2.attendance THEN 'increased'
			 ELSE '' END AS increased_attendance
		FROM ws_teams as ws1
		INNER JOIN ws_teams as ws2 USING (name)
		WHERE ws1.wswin='Y'
			AND ws2.yearid=ws1.yearid+1
			AND ws1.attendance IS NOT NULL
			AND ws2.attendance IS NOT NULL
		ORDER BY ws1.yearid) AS increased_attend
WHERE increased_attendance='increased';

/* 57 TEAMS SAW AN INCREASE IN ATTENDANCE THE YEAR
   AFTER WINNING THE WORLD SERIES
*/  




/*What about teams that made the playoffs? 
Making the playoffs means either being a division winner or a wild card winner.
*/

--LOOK BACK OVER

WITH po_teams as (SELECT yearid,
				   name,
				   divwin,
				   wcwin,
				   attendance
					FROM teams
					WHERE name IN (SELECT name
						   FROM teams
						   WHERE divwin='Y'
						OR wcwin='Y')
					ORDER BY name,
							 yearid)
							 
SELECT *,
		CASE WHEN po1.attendance<po2.attendance THEN 'increased'
			 ELSE '' END AS increased_attendance
FROM po_teams as po1
INNER JOIN po_teams as po2 USING (name)
WHERE po1.divwin='Y'
	  OR po2.wcwin='Y'
	 AND po2.yearid=po1.yearid+1
	AND po1.attendance IS NOT NULL
	AND po2.attendance IS NOT NULL
ORDER BY po1.yearid;

