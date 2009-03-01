#!/bin/sh

#set -x

BACKUPDIR=/backup/Backup_MediaWiki/inno10
REMOTEUSER=macario
REMOTEHOST=inno10.venaria.marelli.it
REMOTEDIR=/home/macario/do_backup_mediawiki

WIKIS=""
WIKIS+="innowiki "
WIKIS+="nbtwiki "
WIKIS+="osstbox "

MEDIAWIKI_ARCHIVE=`date '+%Y%m%d'`-mediawiki_install.tgz

echo "INFO: $0 v0.1"

# Backup MySQL
echo "INFO: Creating backup of MySQL DB from $REMOTEHOST"
mkdir -p $BACKUPDIR || exit 1
ssh $REMOTEUSER@$REMOTEHOST "(cd $REMOTEDIR && ./automysqlbackup_inno10.sh)" || exit 1

echo "INFO: Copying backup of MySQL DB from $REMOTEHOST"
scp -r $REMOTEUSER@$REMOTEHOST:$REMOTEDIR/mysql_backups $BACKUPDIR || exit 1

# Backup MediaWiki engine
echo "INFO: Backing up MediaWiki engine at $REMOTEHOST"
ssh $REMOTEUSER@$REMOTEHOST \
	"(cd /var/www && tar cvz mediawiki-1.9.3 $WIKIS)" \
	> $BACKUPDIR/$MEDIAWIKI_ARCHIVE || exit 1

## Backup Images
#for wiki in $WIKIS; do
#	echo "INFO: Backing up images from $wiki at $REMOTEHOST"
#	mkdir -p $BACKUPDIR/$wiki || exit 1
#	scp -r $REMOTEUSER@$REMOTEHOST:/var/www/$wiki/images \
#		$BACKUPDIR/$wiki || exit 1
#done

# Backup MediaWiki engine

# === EOF ===
