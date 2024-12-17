SELECT
    AVG(friendCount) AS averageNumberOfFriends
FROM
    (
        SELECT
            u.author_id,
            COUNT(uf.friend_author_id) AS friendCount
        FROM
            users u
            LEFT JOIN user_friends uf ON u.author_id = uf.user_author_id
        GROUP BY
            u.author_id
    )