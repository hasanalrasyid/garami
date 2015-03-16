#!/bin/bash
export g09root=/share/apps
source $g09root/g09.profile
chmod oug+rwx $(pwd)
/share/apps/g09runnerLocal $1 &
echo kerja $1 sedang dijalankan
echo ========================================== 

