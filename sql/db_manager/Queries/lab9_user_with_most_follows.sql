SELECT 
	u.first_name,
	u.second_name,
	COUNT(uf.followed_user_author_id) AS numberOfFollows
FROM users u
	JOIN user_followed uf ON uf.user_author_id = u.author_id
GROUP BY 
	u.author_id,
	u.first_name,
	u.second_name
ORDER BY numberOfFollows DESC
LIMIT 1;