SELECT 
    p.id,
    p.title,
    a.city,
	a.country
FROM 
    posts p
JOIN 
    locations l ON l.id = p.location_id
JOIN 
    addresses a ON a.id = l.address_id
WHERE 
    l.geolocation_id IN (
        SELECT 
            g.id
        FROM 
            geolocations g
        ORDER BY 
            ST_Distance(
                g.geom::geography, 
                ST_MakePoint(-122.4194, 37.7749)::geography
            ) ASC
        LIMIT 5
    );
