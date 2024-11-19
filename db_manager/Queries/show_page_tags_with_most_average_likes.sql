SELECT t.tag_name, ROUND(AVG(p.likes)) AS averageLikes, ROUND(AVG(p.views), 2) AS averageViews 
FROM tags t
JOIN page_tags pt ON t.id = pt.tag_id
JOIN pages p ON pt.page_id = p.id
GROUP BY t.tag_name
ORDER BY averageLikes DESC, averageViews DESC
LIMIT 20;