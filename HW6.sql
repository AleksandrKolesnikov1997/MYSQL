-- 1. Создать и заполнить таблицы лайков и постов:
CREATE TABLE likes (
  id SERIAL PRIMARY KEY,
  create_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP     COMMENT 'Время лайка',
  like_type BOOLEAN NOT NULL DEFAULT true                   COMMENT 'Признак лайка',
  from_user_id INT NOT NULL                                 COMMENT 'Чей лайк',
  to_user_id INT                                            COMMENT 'Лайк пользователя',
  media_id INT                                              COMMENT 'Лайк для файла'
)                                                           COMMENT 'Лайки';

CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  create_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP     COMMENT 'Время создания поста',
  changes_at DATETIME ON UPDATE CURRENT_TIMESTAMP           COMMENT 'Время изменения поста',
  text_posts LONGTEXT NOT NULL                              COMMENT 'Текст поста',
  from_user_id INT NOT NULL                                 COMMENT 'Чей пост',
  media_id INT                                              COMMENT 'Медиафайл поста'
)                                                           COMMENT 'Посты';

-- 2. Создать все необходимые внешние ключи и диаграмму отношений:
 ALTER TABLE profiles
   ADD CONSTRAINT profiles_user_id_fk
     FOREIGN KEY (user_id) REFERENCES users(id)
       ON DELETE CASCADE,
   ADD CONSTRAINT profiles_photo_id_fk
     FOREIGN KEY (photo_id) REFERENCES media(id)
       ON DELETE SET NULL;

 ALTER TABLE messages
   ADD CONSTRAINT messages_from_user_id_fk
     FOREIGN KEY (from_user_id) REFERENCES users(id),
   ADD CONSTRAINT messages_to_user_id_fk
     FOREIGN KEY (to_user_id) REFERENCES users(id);


-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины:
SELECT
	(SELECT gender FROM profiles WHERE user_id = likes.user_id) AS gender
    FROM likes;
SELECT
	(SELECT gender FROM profiles WHERE user_id = likes.user_id) AS gender,
	COUNT(*) AS total
    FROM likes
    GROUP BY gender
    ORDER BY total DESC
    LIMIT 1;

-- 4. Подсчитать количество лайков которые получили 10 самых молодых пользователей:
SELECT * FROM profiles ORDER BY birthday DESC LIMIT 10;

SELECT
  (SELECT COUNT(*) FROM likes WHERE /**/target_id/**/ = profiles.user_id AND target_type_id = 2) AS likes_total
  FROM profiles
  ORDER BY birthday
  DESC LIMIT 10;

SELECT SUM(likes_total) FROM
  (SELECT
    (SELECT COUNT(*) FROM likes WHERE target_id = profiles.user_id AND target_type_id = 2) AS likes_total
    FROM profiles
    ORDER BY birthday
    DESC LIMIT 10) AS user_like

-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети:
SELECT
  CONCAT(first_name, ' ', last_name) AS user,
	(SELECT COUNT(*) FROM likes WHERE likes.user_id = users.id) +
	(SELECT COUNT(*) FROM media WHERE media.user_id = users.id) +
	(SELECT COUNT(*) FROM messages WHERE messages.from_user_id = users.id) AS overall_activity
	  FROM users
	  ORDER BY overall_activity
	  LIMIT 10;
