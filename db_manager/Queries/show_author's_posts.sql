SELECT p.id, p.created_at, l.country, l.city, p.title, p.content
FROM posts p
LEFT JOIN locations l ON p.location_id = l.id
WHERE p.is_public = 'true' AND p.author_id = 1
ORDER BY p.created_at DESC