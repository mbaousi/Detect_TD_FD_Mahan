#!/bin/bash
rm -f /home/user-LTE-TD-FD.xls
rm -f /home/user-lte.xls
date=$(date +"%Y-%m-%d")
sshpass -p oos0Aichei9el scp   -o StrictHostKeyChecking=no root@172.24.17.242:/var/log/IBSng/RADIUS/alive.log.1.gz /home/td-fd-detect
cd /home/td-fd-detect
zcat alive.log.1.gz | grep -i 'ibs_alive:Accounting-Request packet from host 10.1.1.1' -A  33 | grep -E "3GPP-SGSN-MCC-MNC|User-Name|3GPP-IMSI" | grep -vi '3GPP-IMSI-MCC-MNC' | cut -d '=' -f2  | xargs -n3 | tr ' ' ',' | sed 's\,43244,\,TD,\g' | sed 's\,43211,\,FD,\g'  >> /home/td-fd-detect/user-lte-$(date +%Y%m%d).xls

cat  /home/td-fd-detect/user-lte-$(date +%Y%m%d).xls | sort -n | uniq  > /home/td-fd-detect/user-LTE-TD-FD-$(date +%Y%m%d).xls
rm /home/td-fd-detect/user-lte-$(date +%Y%m%d).xls
mv /home/td-fd-detect/user-LTE-TD-FD-$(date +%Y%m%d).xls /var/www/html/report/
#sendemail -f 'm.baousi@gmail.com' -t 'manager@mahannet.ir' -cc 'info@mahanvoip.com' -bcc 'm.baousi@gmail.com' -a user-LTE-TD-FD-$(date +%Y%m%d).xls -u "TD-FD-$date" -m "This email is to detect LTE  users on $date" -o message-file="$date" -s smtp.gmail.com:587 -xu m.baousi -xp 123456milad

rm alive.log.1.gz
