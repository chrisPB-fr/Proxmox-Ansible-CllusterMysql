#!/bin/sh

### HOST
FICHIER_HOST=/home/cp219538/hosts
TYPE_HOST=node0
TYPE_SERVER=sql

## RESEAU
GATEWAY="192.168.1.1"
NAMESERVER="192.168.1.1"
DOMAINE="house.cpb"
MASK_IP="192.168.1.11"

## VM
TRIGRAME=100
SIZE_DISK=10G
DATASTORE=DataStore02
PATH_DATA=/mnt/pve/DataStore02
#cd $PATH_DATA 


##################################
#    Deploy Centos8 Template  
##################################

### Creation Template  ###

#wget https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2
qm create 9000 --memory 2048 --name centos-8-template --net0 virtio,bridge=vmbr0
qm importdisk 9000 CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2 local-lvm
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --serial0 socket --vga serial0
qm template 9000

j=0;
for i in `cat $FICHIER_HOST |grep -i $TYPE_HOST |grep -i sql|sort |uniq`;
do
j=$(($j + 1))

#### Machine Clone 9000
qm clone 9000 $TRIGRAME$j --name $i


#### Reseau de la machine $i 
qm set $TRIGRAME$j --ipconfig0 ip=$MASK_IP$j/24,gw=$GATEWAY
qm set $TRIGRAME$j --searchdomain $DOMAINE
qm set $TRIGRAME$j --nameserver $NAMESERVER

## Taile Disque
qm resize $TRIGRAME$j scsi0 $SIZE_DISK

#User
qm set $TRIGRAME$j --ciuser root
qm set $TRIGRAME$j --cipassword Saet5470
qm set $TRIGRAME$j --sshkey ~/.ssh/id_rsa.pub

#Regenere Dump
qm set $TRIGRAME$j --ide2 none,media=cdrom
qm set $TRIGRAME$j --ide2 local-lvm:cloudinit

# Deplace la VM sur le DATASTORE
qm move_disk $TRIGRAME$j scsi0 $DATASTORE

qm start $TRIGRAME$j

### Inscrit les Host dans /etc/hosts
echo "$MASK_IP$j $i" >> /etc/hosts

done

echo ""
echo "Attends 30sec - Démarrage des Machines ...."
sleep 30 

### Insere les Clef SHA dans knows_hosts
### Récupère les Clef des Hosts dans .ssh/known_hosts
rm /root/.ssh/known_hosts && touch /root/.ssh/known_hosts && chmod 0644 /root/.ssh/known_hosts
/usr/bin/ssh-keyscan -t ecdsa-sha2-nistp256 node01-sql >> /root/.ssh/known_hosts
/usr/bin/ssh-keyscan -t ecdsa-sha2-nistp256 node02-sql >> /root/.ssh/known_hosts
/usr/bin/ssh-keyscan -t ecdsa-sha2-nistp256 node03-sql >> /root/.ssh/known_hosts
/usr/bin/ssh-keyscan -t ecdsa-sha2-nistp256 node04-sql >> /root/.ssh/known_hosts

echo ""
echo "Attends 5m pour l'update des nodes via les dépots..."
echo ""
sleep 5m
echo ""
echo "Encore 5 minutes..."
echo ""
sleep 5m
echo "Allez encore 1 minutes... :-) "
sleep 1m
