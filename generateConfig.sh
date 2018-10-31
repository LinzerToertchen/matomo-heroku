#!/usr/bin/env bash

TRUSTED_HOSTS=$(echo $MATOMO_TRUSTED_HOSTS | tr ";" "\n")

cat <<EOF
; <?php exit; ?> DO NOT REMOVE THIS LINE

[database]
host = "$MATOMO_DATABASE_HOST"
username = "$MATOMO_DATABASE_USERNAME"
password = "$MATOMO_DATABASE_PASSWORD"
dbname = "$MATOMO_DATABASE_NAME"
tables_prefix = "$MATOMO_DATABASE_PREFIX"
port = $MATOMO_DATABASE_PORT

[General]

; to get the user's real IP
proxy_client_headers[] = HTTP_X_FORWARDED_FOR

; when set to 1, all requests to Matomo will return a maintenance message without connecting to the DB
; this is useful when upgrading using the shell command, to prevent other users from accessing the UI while Upgrade is in progress
maintenance_mode = 0

; Defines the release channel that shall be used. Currently available values are:
; "latest_stable", "latest_beta", "latest_2x_stable", "latest_2x_beta"
release_channel = "latest_stable"

; by default, Matomo uses PHP's built-in file-based session save handler with lock files.
; For clusters, use dbtable.
session_save_handler = dbtable

; If set to 1, Matomo will automatically redirect all http:// requests to https://
; If SSL / https is not correctly configured on the server, this will break Matomo
; If you set this to 1, and your SSL configuration breaks later on, you can always edit this back to 0
; it is recommended for security reasons to always use Matomo over https
force_ssl = 1

EOF

for host in $TRUSTED_HOSTS
do
    echo "trusted_hosts[] = \"$host\""
done
