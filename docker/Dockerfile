# mariadb 10.3.6
FROM mariadb:10.3.6
MAINTAINER waterchestnut

# Configuring a Systems Backup User and Assigning Permissions
RUN set -ex; \
        grep backup /etc/passwd /etc/group; \
        usermod -aG mysql backup; \
        grep backup /etc/group; \
        exec su - ${USER}; \
        id -nG; \
        find /var/lib/mysql -type d -exec chmod 750 {} \;

# Creating the Backup Assets
COPY  ./backup.cnf   /etc/mysql/backup.cnf
RUN set -ex; \
        chown backup /etc/mysql/backup.cnf; \
        chmod 600 /etc/mysql/backup.cnf; \
        mkdir -p /backups/mysql; \
        chown backup:mysql /backups/mysql

# Copy the Backup and Restore Scripts
COPY ./*-mysql.sh /usr/local/bin/
RUN set -ex; \
        chmod +x    /usr/local/bin/*-mysql.sh

# install cron、sudo and mariabackup
RUN set -ex; \
        apt-get update; \
        apt-get install -y --no-install-recommends mariadb-backup-10.3 cron sudo; \
        rm -rf /var/lib/apt/lists/*

# Creating a Cron Job to Run Backups Hourly
COPY  ./cron.sh   /etc/cron.hourly/backup-mysql
RUN chmod +x /etc/cron.hourly/backup-mysql

CMD ["mysqld"]
