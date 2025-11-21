#!/bin/bash
set -e # Detener si hay error

# --- CONFIGURACIÓN ---
PROJECT_DIR="/home/sysadmin/NextCloud_IaC_G" # Ruta donde está el docker-compose.yml
BACKUP_DIR="/tmp"
TIMESTAMP=$(date +"%Y-%m-%d_%H%M")
FILENAME="backup_nextcloud_${TIMESTAMP}.tar.gz"
FILEPATH="${BACKUP_DIR}/${FILENAME}"

# --- EJECUCIÓN ---
cd "$PROJECT_DIR"

# 1. Detener contenedores (Cold Backup para integridad de DB)
# Usamos 'docker compose stop' en lugar de 'down' para no borrar redes/contenedores, solo pararlos.
docker compose stop

# 2. Comprimir todo (Datos + Configuración)
# Excluimos archivos temporales o git para ahorrar espacio si es necesario
tar -czf "$FILEPATH" .

# 3. Levantar contenedores inmediatamente (Minimizar Downtime)
docker compose start

# 4. Output para el Host (El Host leerá la última línea para saber qué descargar)
echo "$FILEPATH"
