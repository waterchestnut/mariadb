CREATE USER 'backup'@'localhost' IDENTIFIED BY 'password';
GRANT RELOAD, LOCK TABLES, REPLICATION CLIENT, CREATE TABLESPACE, PROCESS, SUPER, CREATE, INSERT, SELECT ON *.* TO 'backup'@'localhost';
FLUSH PRIVILEGES;