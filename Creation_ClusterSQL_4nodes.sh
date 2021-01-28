echo "Deploiement de 4 Node Cluster sur Proxmox...."
echo ""
$PWD/script/01-ClusterSQL_Deploy.sh

echo ""
echo "Deploiement de la Solution PERCONA MariaDB Cluster"
ansible-playbook $PWD/playbook/02-ClusterSql.yml

echo "Deploiement de la Conf SQL pour le Node01-SQL"
echo ""
ansible-playbook $PWD/playbook/03-ConfNode01.yml

echo "Deploiement de la Conf SQL pour le Node02-SQL"
echo ""
ansible-playbook $PWD/playbook/04-ConfNode02.yml

echo "Deploiement de la Conf SQL pour le Node03-SQL"
echo ""
ansible-playbook $PWD/playbook/05-ConfNode03.yml

echo "Deploiement de la Conf SQL pour le Node04-SQL"
echo ""
ansible-playbook $PWD/playbook/06-ConfNode04.yml
