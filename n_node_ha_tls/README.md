# n-node HA Example

This example assumes the following:

3 CentOS instances for the Morpheus UI
3 CentOS instances for the Percona XtraDB

## Setup
Run the following in the example directory

`ansible-galaxy install -r roles/requirements.yml --roles-path=roles/`

## RabbitMQ
RabbitMQ will be running on the UI nodes, but will not be using the version bundled with Morpheus.

TLS will be enabled for clustered communication as well as client connections.  

## Elasticsearch
Elasticsearch will be clustered among the UI nodes.  It's using the Morpheus embedded version.  

## Percona DB
Percona XtraDB will be installed on the 3 DB nodes with the options specified in group_vars/all.

TLS will be enabled between the cluster nodes as well as client connections.
