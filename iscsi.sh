#!/bin/sh
targetcli /backstores/block create disk01 /dev/sdb
targetcli /iscsi create iqn.2018-09.ru.otus:storage.target00
targetcli /iscsi/iqn.2018-09.ru.otus:storage.target00/tpg1/portals create 0.0.0.0
targetcli /iscsi/iqn.2018-09.ru.otus:storage.target00/tpg1/luns create /backstores/block/disk01 lun=1
targetcli /iscsi/iqn.2018-09.ru.otus:storage.target00/tpg1/luns ls lun1
targetcli /iscsi/iqn.2018-09.ru.otus:storage.target00/tpg1 set attribute authentication=0
targetcli /iscsi/iqn.2018-09.ru.otus:storage.target00/tpg1 set auth userid=otus
targetcli /iscsi/iqn.2018-09.ru.otus:storage.target00/tpg1 set auth password=otus
cat /etc/iscsi/initiatorname.iscsi | grep -oP '=\K.*' > Z
f=$(cat Z)
targetcli /iscsi/iqn.2018-09.ru.otus:storage.target00/tpg1/acls create $f
iscsiadm -m discovery -t st -p 10.1.0.1
iscsiadm -m node -l -T iqn.2018-09.ru.otus:storage.target00
iscsiadm -m node -T iqn.2018-09.ru.otus:storage.target00
