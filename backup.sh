#!/bin/sh

cd /mount
gitea dump -c /etc/gitea/app.ini
cp /etc/gitea/app.ini /mount/app-`date +%s`.ini
echo "Moved backup to shared directory"
