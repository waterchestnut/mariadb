# mariadb 10.5.9
FROM mariadb:10.5.9
MAINTAINER waterchestnut

# Configuring a Systems Backup User and Assigning Permissions
RUN set -ex; \
        grep backup /etc/passwd /etc/group; \
        usermod -aG mysql backup; \
        grep backup /etc/group; \
        # exec su - ${USER}; \ # stdin: is not a tty
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
        apt-get install -y --no-install-recommends mariadb-backup cron sudo; \
        rm -rf /var/lib/apt/lists/*

# install qpress
RUN set -ex; \
        wget http://www.quicklz.com/qpress-11-linux-x64.tar; \
        tar xvf qpress-11-linux-x64.tar; \
        cp qpress /usr/bin; \
        chmod 755 /usr/bin/qpress

# Creating a Cron Job to Run Backups Hourly
# ?可能磁盘分区不同，cron任务不能执行：
# 容器内执行 ls -l /etc/cron.d/backup-mysql，显示的文件个数是3
# 容器内执行 chmod +x /etc/cron.d/backup-mysql后，可以正常执行cron任务
# 测试有问题的服务器磁盘分区格式为xfs，能正常运行的服务器磁盘分区格式为ext3
COPY  ./cron.sh   /etc/cron.hourly/backup-mysql
RUN chmod +x /etc/cron.hourly/backup-mysql
COPY  ./crontab   /etc/cron.d/backup-mysql
RUN chmod +x /etc/cron.d/backup-mysql

VOLUME ["/backups/mysql"]
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
