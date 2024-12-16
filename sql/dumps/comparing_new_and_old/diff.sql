
-- Add foreign key constraints for Article
ALTER TABLE articles
ADD CONSTRAINT fk_articles_author_id
FOREIGN KEY (author_id) REFERENCES authors(id)
ON DELETE CASCADE;

-- Add many-to-many relationship for Article and Hashtag
CREATE TABLE article_hashtags (
    article_id uint NOT NULL,
    hashtag_id uint NOT NULL,
    PRIMARY KEY (article_id, hashtag_id),
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (hashtag_id) REFERENCES hashtags(id) ON DELETE CASCADE
);

-- Add foreign key constraints for Section
ALTER TABLE sections
ADD CONSTRAINT fk_sections_article_id
FOREIGN KEY (article_id) REFERENCES articles(id)
ON DELETE CASCADE;

-- Add many-to-many relationship for User and FollowedUsers
CREATE TABLE user_followed (
    user_id uint NOT NULL,
    followed_user_id uint NOT NULL,
    PRIMARY KEY (user_id, followed_user_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (followed_user_id) REFERENCES users(id) ON DELETE CASCADE
);