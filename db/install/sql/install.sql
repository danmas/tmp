\set ECHO all
\qecho 'Installing DB schema'

/* Creating tables first */
\i ./sql/create_tables.sql

/* Stored functions */
\i ./sql/api_procedures.sql

\qecho 'Done.'
