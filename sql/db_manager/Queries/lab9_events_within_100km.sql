SELECT 
    e.name,
    a.city,
    ST_Distance(
        g.geom::geography, 
        ST_MakePoint(-122.4194, 37.7749)::geography
    ) AS distance
FROM 
    events e
JOIN 
    locations l ON l.id = e.location_id
JOIN 
    addresses a ON a.id = l.address_id
JOIN
    geolocations g ON g.id = l.geolocation_id
WHERE 
    ST_DWithin(
        g.geom::geography, 
        ST_MakePoint(-122.4194, 37.7749)::geography,
        100000
    )
ORDER BY
    distance ASC;
