# Morpheus Installation Using Ansible
This is a tutorial on getting Morpheus up and running on CentOS 7 using Ansible.
You will need: 
- A workstation running Ansible
- Enough VMs to run your chosen installation type:
  - All-in-one Appliance:
    - 1 VM
    - 2 Cores
    - 16 GB RAM
    - 200 GB Storage
  - Full HA Installation
    - 9 VMs
    - 2 Cores
    - 16 GB RAM for DBs, 8 GB RAM for UI, Elasticsearch nodes
    - 200 GB Each
    - Shared Storage for the UI nodes (optional)

NOTE: This is written for Mac users, Windows users should use WSL Ubuntu for similar functionality.

## Single Appliance

This assumes you have password-less sudo access or that you are accessing your VM as root.  If this is not the case, see the following page for details on how to configure that correctly for Ansible: [Ansible Become Documentation](https://docs.ansible.com/ansible/latest/user_guide/become.html)

Note: If you have a FQDN for your VM, you can put it in all_in_one.yml as the value for `morpheus_appliance_url`.  Otherwise, it will use whatever is in the inventory file.

Run the following:
```
VMIP=<your VM IP address>
git clone https://github.com/tryfan/ansible-morpheus-examples
cd ansible-morpheus-examples/all-in-one
echo "[morpheus]
$VMIP" >> inventory
ansible-galaxy install -r roles/requirements.yml --roles-path=roles/
ansible-playbook -i inventory all_in_one.yml
```

## n-node HA Example

This example assumes the following:

3 CentOS instances for the Morpheus UI

3 CentOS instances for Elasticsearch

3 CentOS instances for the Percona XtraDB

RabbitMQ will be running on the UI nodes, but will not be using the version bundled with Morpheus.  Elasticsearch will be clustered among the UI nodes.  Percona XtraDB will be installed on the 3 DB nodes with the options specified in group_vars/all.

Feel free to customize group_vars/all for any password changes, etc.  Use inventory.dist as a template for your ansible inventory.  The `morpheus_appliance_url` should be a load balancer pointed to the Morpheus nodes.  In absence of a load balancer, the default is the first Morpheus node listed in the inventory in the `[morpheus]` group.

```
ansible-galaxy install -r roles/requirements.yml --roles-path=roles/
ansible-playbook -i inventory n_node_ha.yml
``` 

## n-node HA TLS Example

This will install TLS encrypted configurations of the standard HA deployment.  

This example assumes the following:

3 CentOS instances for the Morpheus UI

3 CentOS instances for Elasticsearch

3 CentOS instances for the Percona XtraDB

RabbitMQ will be running on the UI nodes, but will not be using the version bundled with Morpheus.  Elasticsearch will be clustered among the UI nodes.  Percona XtraDB will be installed on the 3 DB nodes with the options specified in group_vars/all.

Feel free to customize group_vars/all for any password changes, etc.  Use inventory.dist as a template for your ansible inventory.  The `morpheus_appliance_url` should be a load balancer pointed to the Morpheus nodes.  In absence of a load balancer, the default is the first Morpheus node listed in the inventory in the `[morpheus]` group.

```
ansible-galaxy install -r roles/requirements.yml --roles-path=roles/
ansible-playbook -i inventory n_node_ha.yml
``` 