SELECT friendsOfFriends.user_author_id, u.first_name, u.second_name, COUNT(*) AS mutualFriendsCount
FROM user_friends friendsOfUser
JOIN user_friends friendsOfFriends ON friendsOfUser.friend_author_id = friendsOfFriends.friend_author_id
JOIN users u ON friendsOfFriends.user_author_id = u.author_id
WHERE friendsOfUser.user_author_id = 1 AND friendsOfFriends.user_author_id != 1
GROUP BY friendsOfFriends.user_author_id, u.first_name, u.second_name
ORDER BY mutualFriendsCount DESC, u.second_name ASC, u.first_name ASC;
	