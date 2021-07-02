-- Часть 1
-- Задание 1
UPDATE
  users
SET
  created_at = NOW(),
  updated_at = NOW();


-- Задание 2
UPDATE
  users
SET
  created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
  updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');

ALTER TABLE
  users
CHANGE
  created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE
  users
CHANGE
  updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

DESCRIBE users;


-- Задание 3
SELECT
  *
FROM
  storehouses_products
ORDER BY
  IF(value > 0, 0, 1),
  value;

SELECT
  *
FROM
  storehouses_products
ORDER BY
  value = 0, value;



-- Часть 2
-- Задание 1
SELECT
  AVG(TIMESTAMPED(YEAR, birthday_at, NOW())) AS age
FROM
  users;

-- Задание 2
SELECT
  DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS day,
  COUNT(*) AS total
FROM
  users
GROUP BY
  day
ORDER BY
  total DESC;
