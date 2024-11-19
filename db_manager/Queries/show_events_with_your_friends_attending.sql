SELECT e.id, e.name, e.start_date, e.end_date, COUNT(em.author_id) AS numberOfFriendsAttending
FROM events e
JOIN event_members em ON e.id = em.event_id
WHERE (
	em.author_id IN (
		SELECT uf.friend_author_id
		FROM user_friends uf
		WHERE uf.user_author_id = 1
	)
) AND e.end_date >= Now()
GROUP BY e.id, e.name, e.start_date, e.end_date
ORDER BY numberOfFriendsAttending DESC, e.start_date ASC