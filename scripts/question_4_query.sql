--Question 4

SELECT CASE WHEN pos='OF' THEN 'Outfield'
	   		WHEN pos IN ('SS','1B','2B','3B') THEN 'Infield'
			WHEN pos IN ('P','C') THEN 'Battery'
			END AS player_position,
		SUM(po) as total_po
FROM fielding
WHERE yearid='2016'
GROUP BY player_position
ORDER BY total_po DESC;

/*Answer: Infield		58,934
		  Battery		41,424
		  Outfield		29,560
*/

