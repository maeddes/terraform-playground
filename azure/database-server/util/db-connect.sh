# MySQL client needs to be installed. Path to certificate might need to be specified (--ssl-ca=/path/to/certificate.crt.pem)
# Download certificate here: https://www.digicert.com/CACerts/BaltimoreCyberTrustRoot.crt.pem
mysql --host $(terraform output db-hostname) --user dbadmin@mariadb-server -p --ssl-mode=REQUIRED
