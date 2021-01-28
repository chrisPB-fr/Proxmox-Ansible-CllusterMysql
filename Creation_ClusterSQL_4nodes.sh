echo "Deploiement de 4 Node Cluster sur Proxmox...."
echo ""
/home/cp219538/Proxmox-Ansible-ClusterMysql/01-ClusterSQL_Deploy.sh

echo ""
echo "Deploiement de la Solution PERCONA MariaDB Cluster"
ansible-playbook /home/cp219538/Proxmox-Ansible-ClusterMysql/playbook/02-ClusterSql.yml

echo "Deploiement de la Conf SQL pour le Node01-SQL"
echo ""
ansible-playbook /home/cp219538/Proxmox-Ansible-ClusterMysql/playbook/03-ConfNode01.yml

echo "Deploiement de la Conf SQL pour le Node02-SQL"
echo ""
ansible-playbook /home/cp219538/Proxmox-Ansible-ClusterMysql/playbook/04-ConfNode02.yml

echo "Deploiement de la Conf SQL pour le Node03-SQL"
echo ""
ansible-playbook /home/cp219538/Proxmox-Ansible-ClusterMysql/playbook/05-ConfNode03.yml

echo "Deploiement de la Conf SQL pour le Node04-SQL"
echo ""
ansible-playbook /home/cp219538/Proxmox-Ansible-ClusterMysql/playbook/06-ConfNode04.yml
