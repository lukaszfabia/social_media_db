SELECT 
	l.id,
	a.country,
	a.city,
	a.street_name,
	a.apartment,	
	g.geom
FROM locations l
	JOIN addresses a on a.id = l.id
	JOIN geolocations g on g.id = l.id;
