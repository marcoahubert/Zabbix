#!/bin/bash

# Configurações do backup
SOURCE_DIR="/server/"  # Diretório de origem
DEST_DIR="/mnt/backup/"    # Diretório de destino
RSYNC_LOG="/var/log/backup_rsync.log"
ZABBIX_SENDER="/usr/bin/zabbix_sender"
ZABBIX_CONF="/etc/zabbix/zabbix_agentd.conf"
ZABBIX_KEY="backup.status"    # Chave no Zabbix
HOSTNAME="ZabbixServer"      # Hostname configurado no Zabbix

# Executa o backup com rsync
rsync -av --no-perms --no-owner --no-group --log-file="$RSYNC_LOG" "$SOURCE_DIR" "$DEST_DIR"

# Verifica o status do rsync
if [ $? -eq 0 ]; then
    STATUS="OK"
    ZABBIX_VALUE=1
else
    STATUS="FAIL"
    ZABBIX_VALUE=0
fi

# Log do resultado
echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup $STATUS" >> "$RSYNC_LOG"

# Envia o status para o Zabbix
$ZABBIX_SENDER -c "$ZABBIX_CONF" -k "$ZABBIX_KEY" -o "$ZABBIX_VALUE" -s "$HOSTNAME"

# Verifica se o envio ao Zabbix foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Status $STATUS enviado ao Zabbix" >> "$RSYNC_LOG"
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Falha ao enviar status ao Zabbix" >> "$RSYNC_LOG"
fi


