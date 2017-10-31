Etcd cluster on VirtualBox and Vagrant 
======================================

Spin up VirtualBox VM and install etcd using Chef and Vagrant

Install Virtual Box on MAC:
---------------------------
http://download.virtualbox.org/virtualbox/5.1.30/VirtualBox-5.1.30-118389-OSX.dmg

Install Vagrant:
----------------
https://releases.hashicorp.com/vagrant/2.0.0/vagrant_2.0.0_x86_64.dmg


Install Ubuntu/Xenial 16.04 Virtual VM using Vagrant:
------------------------------------------------------
```
$ mkdir my_etcd
$ cd my_etcd
$ vagrant init
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.

$ vagrant box add ubuntu/xenial64
==> box: Loading metadata for box 'ubuntu/xenial64'
    box: URL: https://vagrantcloud.com/ubuntu/xenial64
==> box: Adding box 'ubuntu/xenial64' (v20171011.0.0) for provider: virtualbox
    box: Downloading: https://vagrantcloud.com/ubuntu/boxes/xenial64/versions/20171011.0.0/providers/virtualbox.box
==> box: Successfully added box 'ubuntu/xenial64' (v20171011.0.0) for 'virtualbox'!
```
Check if Vagrant Box was downloaded
```
$ vagrant box list
ubuntu/xenial64 (virtualbox, 20171011.0.0)
```

Modify Vagrantfile to add ansible (For 3 Node Etcd cluster):
-----------------------------------------------------------
```
$ egrep -v "^$|^#| #" Vagrantfile 
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
      
  
  config.vm.define :etcd1 do |etcd1|
    etcd1.vm.box = "ubuntu/xenial64"
    etcd1.vm.hostname = "etcd1"
    etcd1.vm.network :private_network, ip: "192.168.56.201"
    etcd1.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "2048"]
      v.customize ["modifyvm", :id, "--cpus", "2"]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
      v.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
      v.gui = true
    end
    etcd1.vm.provision "shell", inline: "curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -v 13.2.20"
    etcd1.vm.provision "chef_zero" do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.nodes_path = "cookbooks/nodes"
  
      chef.add_recipe "install_etcd"
  
    end
  end
  config.vm.define :etcd2 do |etcd2|
    etcd2.vm.box = "ubuntu/xenial64"
    etcd2.vm.hostname = "etcd2"
    etcd2.vm.network :private_network, ip: "192.168.56.202"
    etcd2.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "2048"]
      v.customize ["modifyvm", :id, "--cpus", "2"]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
      v.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
      v.gui = true
    end
    etcd2.vm.provision "shell", inline: "curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -v 13.2.20"
    etcd2.vm.provision "chef_zero" do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.nodes_path = "cookbooks/nodes"
  
      chef.add_recipe "install_etcd"
  
    end
  end
  config.vm.define :etcd3 do |etcd3|
    etcd3.vm.box = "ubuntu/xenial64"
    etcd3.vm.hostname = "etcd3"
    etcd3.vm.network :private_network, ip: "192.168.56.203"
    etcd3.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "2048"]
      v.customize ["modifyvm", :id, "--cpus", "2"]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
      v.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
      v.gui = true
    end
    etcd3.vm.provision "shell", inline: "curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -v 13.2.20"
    etcd3.vm.provision "chef_zero" do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.nodes_path = "cookbooks/nodes"
  
      chef.add_recipe "install_etcd"
  
    end
  end
end

```
 
Boot up 3 VMs and Install etcd in it using Vagrant
--------------------------------------------------
```
$ vagrant up etcd1 etcd2 etcd3
```

Chef configuration
------------------
```
$ tree ../etcd_vbox/cookbooks/
$ tree ../etcd_vbox/cookbooks/
../etcd_vbox/cookbooks/
├── install_etcd
│   ├── files
│   │   └── check_etcd.sh
│   ├── recipes
│   │   └── default.rb
│   └── templates
│       └── etcd_conf.erb
└── nodes
    ├── etcd1.json
    ├── etcd2.json
    └── etcd3.json

````
Etcd setup
-----------
Log in to one of the etcd VMs and check etcd status
```
root@etcd1:~# etcdctl cluster-health
member 2aef8158ceb1a2bb is healthy: got healthy result from http://192.168.56.201:2379
member 3bc0f367342558b5 is healthy: got healthy result from http://192.168.56.202:2379
member a941e6890ee597a6 is healthy: got healthy result from http://192.168.56.203:2379
cluster is healthy
```


