SELECT e.id, e.name, l.city, a.street_name, a.building, e.start_date, e.end_date, count(em.author_id) AS numberOfMembers
FROM events e
JOIN event_members em ON e.id = em.event_id
JOIN locations l ON e.location_id = l.id
JOIN addresses a ON l.address_id = a.id
WHERE l.city = 'St. Petersburg' AND e.end_date >= Now() AND e.start_date <= Now() + INTERVAL '1 MONTH'
GROUP BY e.id, l.city, a.street_name, a.building
ORDER BY numberOfMembers DESC, e.start_date ASC, e.end_date ASC
