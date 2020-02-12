# n-node HA Example

This example assumes the following:

3 CentOS instances for the Morpheus UI
3 CentOS instances for the Percona XtraDB

RabbitMQ will be running on the UI nodes, but will not be using the version bundled with Morpheus.  Elasticsearch will be clustered among the UI nodes.  Percona XtraDB will be installed on the 3 DB nodes with the options specified in group_vars/all
