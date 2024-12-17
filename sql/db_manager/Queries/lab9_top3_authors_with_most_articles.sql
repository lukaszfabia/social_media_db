
SELECT
    u.author_id,
    u.first_name,
    u.second_name, 
    count(a.id) AS numberOfArticles
FROM
    users u
    JOIN articles a ON a.author_id = u.author_id

GROUP BY
    u.author_id,
    u.first_name,
    u.second_name, 
ORDER BY
    numberOfArticles DESC
LIMIT
    3;