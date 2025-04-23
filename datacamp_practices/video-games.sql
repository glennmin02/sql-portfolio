-- best_selling_games
SELECT * FROM game_sales
ORDER BY games_sold DESC
	LIMIT 10;

-- critics_top_ten_years
SELECT year, num_games, ROUND(avg_critic_score,2) AS avg_critic_score FROM critics_avg_year_rating
ORDER BY avg_critic_score DESC
LIMIT 10;

-- golden_years
SELECT u.year, u.num_games, c.avg_critic_score, u.avg_user_score,c.avg_critic_score - u.avg_user_score AS diff
FROM critics_avg_year_rating c
INNER JOIN users_avg_year_rating u
ON c.year = u.year
WHERE c.avg_critic_score > 9 OR u.avg_user_score > 9
ORDER BY year ASC;
