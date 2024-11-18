SELECT c.id, c.title, lm.lastMessageDate, lm.lastMessageContent
FROM conversations c
JOIN conversation_members cm ON c.id = cm.conversation_id
JOIN (
    SELECT m.conversation_id, m.created_at AS lastMessageDate, m.content AS lastMessageContent
    FROM messages m
    WHERE m.created_at = (
        SELECT MAX(m2.created_at)
        FROM messages m2
        WHERE m2.conversation_id = m.conversation_id
    )
) lm ON c.id = lm.conversation_id
WHERE cm.author_id = 2
ORDER BY lm.lastMessageDate DESC;