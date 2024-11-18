SELECT h.tag_name, COUNT(ph.post_id) + COUNT(ch.comment_id) AS hashtagUsageCount
FROM hashtags h
LEFT JOIN post_hashtags ph ON h.id = ph.hashtag_id
LEFT JOIN comment_hashtags ch ON h.id = ch.hashtag_id
JOIN posts p ON ph.post_id = p.id
JOIN comments c ON ch.comment_id = c.id
WHERE p.created_at >= (NOW() - INTERVAL '7 days') AND c.created_at >= (NOW() - INTERVAL '7 days')
GROUP BY h.tag_name
ORDER BY hashtagUsageCount DESC
LIMIT 10;