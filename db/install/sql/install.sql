\set ECHO all
\qecho 'Installing DB schema'

/* Do before creating tables procedures */
\i ./sql/before_create_tables.sql

/* Creating tables first */
\i ./sql/create_tables.sql

/* Do after creating tables procedures */
\i ./sql/after_create_tables.sql

/* Stored functions */
\i ./sql/api_procedures.sql

\qecho 'Done.'
