SELECT u.author_id, u.first_name, u.second_name, ROUND(AVG(postReactions.reactionCount),2) AS averageReactionsPerPost
FROM users u
JOIN posts p ON u.author_id = p.author_id
JOIN (
    SELECT post_id,COUNT(r.id) AS reactionCount
    FROM reactions r
    GROUP BY r.post_id
) postReactions ON p.id = postReactions.post_id
GROUP BY u.author_id, u.first_name, u.second_name
ORDER BY averageReactionsPerPost DESC
LIMIT 20;