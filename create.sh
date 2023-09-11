apt source openldap 
cd openldap-2.5.13+dfsg/servers/slapd/back-sql/rdbms_depend/pgsql
pgcli 'postgres://ldapsql:69novass@192.168.1.76:5432/ldapsql' << EOF
\i testdb_create.sql;
\i testdb_data.sql;
\i backsql_create.sql;
\i testdb_metadata.sql;
EOF

