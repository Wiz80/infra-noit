#!/bin/bash

# Configurar volumen de datos para PostgreSQL
docker run --rm -v postgres_data:/data -v /data/postgres:/host_data alpine sh -c "cp -rp /host_data/* /data/ && chown -R 999:999 /data"

# Verificar el estado de PostgreSQL
docker-compose restart postgres 