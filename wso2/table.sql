DROP DATABASE WSO2AM_DB;
DROP DATABASE WSO2SHARED_DB;

CREATE DATABASE WSO2AM_DB CHARACTER SET latin1 COLLATE latin1_swedish_ci;
CREATE DATABASE WSO2SHARED_DB CHARACTER SET latin1 COLLATE latin1_swedish_ci;

EXIT;


-- mysql> SELECT @@GLOBAL.sql_mode;
-- +-----------------------------------------------------------------------------------------------------------------------+
-- | @@GLOBAL.sql_mode                                                                                                     |
-- +-----------------------------------------------------------------------------------------------------------------------+
-- | ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION |
-- +-----------------------------------------------------------------------------------------------------------------------+
-- 1 row in set (0.00 sec)

-- mysql> 