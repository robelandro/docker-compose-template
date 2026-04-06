docker exec -it oracle-free sqlplus system/YourStrongPassword123@localhost:1521/FREE

docker exec -it oracle-free sqlplus system/YourStrongPassword123@localhost:1521/FREEPDB1

CREATE USER COBANK_USER IDENTIFIED BY "COBANK_PASSWORD";
GRANT CONNECT, RESOURCE, DBA TO COBANK_USER;
ALTER USER COBANK_USER QUOTA UNLIMITED ON USERS;
