SELECT
   a.title, 
   count(s.id) AS numberOfSections
FROM
    articles a
    JOIN sections s ON s.article_id = a.id
WHERE
    a.created_at >= (NOW() - INTERVAL '30 days')
GROUP BY
    a.title, a.id
ORDER BY
    numberOfSections DESC
LIMIT
    10;