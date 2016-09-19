=========
simplerpc
=========

Simple RPC program using AMQP and managed by SaltStack.

Problem Statement
=================

Install Saltstack (http://www.saltstack.com) on a pair of virtual machines and create
a master/minion configuration. Ideally, use Vagrant for automating the setup (https://www.vagrantup.com/).
Understand how Saltstack works and the concepts of modules, states, beacons, etc.
Implement a new execution/state, beacon, or authentication module of your choice.
We value not only quality of the code but also originality, usefulness, etc.
Point us to the source code.

- Setup a salt cluster with:

  - One master
  - Two minions

- Run basic mathematical operations:

  - Addition
  - Multiplication
  - Division
  - Substraction

- The module should run the operations via. RPC.
- Using AMQP for making asynchronous RPC calls over the salt cluster.
- Should have sufficient test coverage.

Getting Started
===============

- Using Terraform to provision the virtual machines which are running salt master and minion.
- Setup and install [Terraform](https://www.terraform.io/intro/getting-started/install.html) and libvirt/kvm properly.
  - Using [Terraform libvirt plugin.](https://github.com/dmacvicar/terraform-provider-libvirt) for setting up VM's.
- Using a simple [RabbitMQ](https://www.rabbitmq.com/) based [RPC](https://en.wikipedia.org/wiki/Remote_procedure_call) program using [AMQP](https://www.amqp.org/).
- Saltstack will have the following roles in the application:

  * Pull required information about the cluster.
  * Manage the configuration, installation and related tasks for the cluster.
  * Make sure that the program is running as expected and the services are behaving.
  * Monitor and logging.

- To use this repository, just run the ./setup.sh after installing required dependencies:

  * It should automatically setup a three node cluster.
  * Start saltstack on the master.
  * Salt then takes over from here, prepares the cluster.
  * When the cluster is ready, now you may move on to use the RPC program.

- After terraform is finished with deploying the cluster, terraform should provide the required ip addresses.

  * Run command `$ terraform output` to get the ip addresses of the given nodes.
  * You need the private key file, find it here: `utils/keys/masterKey`
  * SSH command: `$ ssh -i utils/keys/masterKey root@<$node_ip>`

- Using the simple_rpc program:

  * Make sure that your cluster is launched!
  * Run the program ...

.. XXX dbite: Finish me ... from getting started!

Weird Little Quirks
===================

- Some limitations or drawbacks from the side of Terraform with libvirt plugin have given the need for the following:
  * Only use ``setup.sh`` for setting up or destroying the cluster.
  * Naming conventions are starting with ``dsalt<rolename><-><number>`` for easily grepping and manual start or delete of the cluster VM's.
- More ..?

Available states
================

.. contents::
    :local:

``simplerpc``
-------------

TODO(dbite): Update description.

Formula Dependencies
====================

None

TODO
====

- [x] Initialize Repository.
- [x] Setup and configure Terraform.
- [x] Setup additional CLI.
- [x] Implement simple math operator module.
- [x] Write basic test cases for the same.
- [x] Setup testing framework.
- [x] Implement required Saltstack modules.
- [ ] Implement RPC module(s).
- [ ] Implement test cases for RPC module.
  * [ ] Unit tests.
  * [ ] Functional tests.
- [ ] Implement test cases for Saltstack modules.
  * [ ] Unit tests.
  * [ ] Functional tests.
- [ ] Implement simple functional/integration tests.
  * [ ] Test Saltstack modules.
  * [ ] Test RPC modules.
  * [ ] Test RPC modules on a running cluster.
