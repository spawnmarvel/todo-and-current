# 

## Table of content

- [](#)
  - [Table of content](#table-of-content)
  - [Kernel Virtual Machine](#kernel-virtual-machine)
  - [KVM hypervisor a beginners’ guide](#kvm-hypervisor-a-beginners-guide)
  - [Lab Setup Strategy for AZ-800 \& AZ-801](#lab-setup-strategy-for-az-800--az-801)

## Kernel Virtual Machine

Linux KVM (Kernel-based Virtual Machine) is a built-in open-source feature that turns your Linux kernel into a high-performance hypervisor

https://linux-kvm.org/page/Main_Page

KVM hypervisor enables full virtualisation capabilities. It provides each VM with all typical services of the physical system, including virtual BIOS (basic input/output system) and virtual hardware, such as processor, memory, storage, network cards, etc. As a result, every VM completely simulates a physical machine.


![tolplogy](https://github.com/spawnmarvel/todo-and-current/blob/main/bash_linux_kvm_hypervisor/images/topology.jpg)

## KVM hypervisor a beginners’ guide

Start by grabbing a fresh physical or virtual machine (yes, you can do nested virtualisation) with 

* 4+ core amd64 CPU
* 16 GB of RAM
* 50 GB of storage 
* and the latest Ubuntu Server LTS installed

https://ubuntu.com/blog/kvm-hyphervisor

## Lab Setup Strategy for AZ-800 & AZ-801

