#!/bin/sh

cd /mount
gitea dump -c /etc/gitea/app.ini
echo "Moved backup to shared directory"
