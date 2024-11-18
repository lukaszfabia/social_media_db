SELECT 
    ROUND(AVG(totalReactions), 2) AS averageReactionsPerPostInLastMonth,
    ROUND(AVG(likeCount), 2) AS averageLikesPerPost,
    ROUND(AVG(loveCount), 2) AS averageLovesPerPost,
    ROUND(AVG(hahaCount), 2) AS averageHahasPerPost,
    ROUND(AVG(wowCount), 2) AS averageWowsPerPost,
    ROUND(AVG(sadCount), 2) AS averageSadsPerPost,
    ROUND(AVG(angryCount), 2) AS averageAngrysPerPost
FROM (
    SELECT 
		p.id,
        COUNT(r.id) AS totalReactions,
        SUM(CASE WHEN r.reaction = 'like' THEN 1 ELSE 0 END) AS likeCount,
        SUM(CASE WHEN r.reaction = 'love' THEN 1 ELSE 0 END) AS loveCount,
        SUM(CASE WHEN r.reaction = 'haha' THEN 1 ELSE 0 END) AS hahaCount,
        SUM(CASE WHEN r.reaction = 'wow' THEN 1 ELSE 0 END) AS wowCount,
        SUM(CASE WHEN r.reaction = 'sad' THEN 1 ELSE 0 END) AS sadCount,
        SUM(CASE WHEN r.reaction = 'angry' THEN 1 ELSE 0 END) AS angryCount
    FROM posts p
    LEFT JOIN reactions r ON p.id = r.post_id
    WHERE p.created_at = Now() - INTERVAL '1 month' AND p.author_id IN (
          SELECT a.id 
          FROM authors a 
          WHERE a.id = (
              SELECT pa.author_id 
              FROM pages pa 
              WHERE pa.id = 2
          )
      )
    GROUP BY p.id
) reactionData;