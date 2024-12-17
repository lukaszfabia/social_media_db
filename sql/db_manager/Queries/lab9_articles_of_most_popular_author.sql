
SELECT
   a.title, 
   u.second_name
FROM
    articles a
    JOIN users u ON a.author_id = u.author_id
WHERE u.author_id = (
	SELECT uf.user_author_id
	FROM user_friends uf
	WHERE uf.user_author_id IN (
		SELECT ar.author_id
		FROM articles ar)
		
	GROUP BY uf.user_author_id
	ORDER BY COUNT(uf.friend_author_id) DESC
	LIMIT 1
)
ORDER BY a.title;
