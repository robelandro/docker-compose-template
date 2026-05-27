#!/bin/bash
# table-definitions.sh
# Dumps all tables and their column definitions for COBANK_USER

CONTAINER="oracle-free"
USER="COBANK_USER"
PASS="COBANK_PASSWORD"
SERVICE="localhost:1521/FREEPDB1"

docker exec -i $CONTAINER sqlplus -s $USER/$PASS@$SERVICE <<'EOF'
SET LINESIZE 200
SET PAGESIZE 200
SET FEEDBACK OFF
SET HEADING ON

PROMPT ================================
PROMPT Tables and Column Definitions
PROMPT ================================

COLUMN table_name FORMAT A30
COLUMN column_name FORMAT A30
COLUMN data_type FORMAT A20
COLUMN data_length FORMAT 9999
COLUMN nullable FORMAT A8

SELECT table_name,
       column_name,
       data_type,
       data_length,
       nullable
FROM user_tab_columns
ORDER BY table_name, column_id;

EXIT
EOF
