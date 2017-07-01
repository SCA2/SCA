#!/bin/bash
pg_dump sca_production > sca_production.$(date.%F).dat.sql
rm -f sca_production.*.tar.gz
tar -cf sca_production.$(date +%F).tar sca_production.$(date +%F).dat.sql
gzip sca_production.$(date +%F).tar
rm -f sca_production.$(date +%F).dat.sql