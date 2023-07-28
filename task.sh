#!/bin/bash
ALL_DB=$(echo "select datname from pg_database where datname != 'postgres' and datname not ilike 'template%' and datname not ilike 'prisma_migrate%'" | psql -t $DATABASE_URL)

while IFS= read -r line; do
  DB=$(echo $line | xargs)
  echo "Dumping $DB..."
  /usr/bin/pg_dump -d "$DATABASE_URL$DB" > "/backup/$DB.psql"
done <<< "$ALL_DB"

DATE=$(date +%Y-%m-%d_%H-%M-%S)
tarsnap -c -f "codeday-pg-$DATE" /backup

rm -rf /backup