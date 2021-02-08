CREATE DEFINER=`root`@`localhost` PROCEDURE `change_table`(IN data JSON)
BEGIN
DECLARE counter INT DEFAULT 0;

SET @json = data;
SET @indx = 0;
SET @keys = JSON_KEYS(@json);

DROP TEMPORARY TABLE IF EXISTS table_1;
CREATE TEMPORARY TABLE table_1(`key` varchar(255), `value` varchar(255));


IF (JSON_VALID(@json) = 1) THEN
WHILE counter < JSON_LENGTH(@json) DO
 
INSERT INTO table_1(`key`, `value`)
VALUES (JSON_EXTRACT(@keys, CONCAT("$[", @indx, "]")), JSON_EXTRACT(@json, CONCAT("$.", JSON_EXTRACT(@keys, CONCAT("$[", @indx, "]")))));
SET counter = counter + 1;
SET @indx = @indx + 1;

END WHILE;
END IF;
IF (JSON_VALID(@json) = 0) THEN
SIGNAL SQLSTATE '45000' SET MYSQL_ERRNO=333, MESSAGE_TEXT='Invalid JSON object';
END IF;

Select * FROM table_1;

END
