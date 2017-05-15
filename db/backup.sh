#!/bin/bash
#cd /path/to/backup/
pg_dump sca_production > sca_production.$(date.%F).dat.sql
tar -cf sca_production.$(date.%F).tar sca_production.$(date.%F).dat.sql
gzip sca_production.$(date.%F).tar
rm -f sca_production.$(date.%F).dat.sql