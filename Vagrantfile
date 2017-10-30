VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
      
  # config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: true
  
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
    # config.vm.synced_folder "vagrant/chef-repo", "/home/ubuntu/chef-repo"
    # Install Chef-client inside Vbox guest VM
    etcd1.vm.provision "shell", inline: "curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -v 13.2.20"
    # Use chef provisioning
    etcd1.vm.provision "chef_zero" do |chef|
      # Specify the local paths where Chef data is stored
      chef.cookbooks_path = "cookbooks"
      #chef.data_bags_path = "data_bags"
      chef.nodes_path = "cookbooks/nodes"
      #chef.roles_path = "roles"
  
      # Add a recipe
      chef.add_recipe "install_etcd"
  
      # Or maybe a role
      #chef.add_role "web"
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
    # config.vm.synced_folder "vagrant/chef-repo", "/home/ubuntu/chef-repo"
    # Install Chef-client inside Vbox guest VM
    etcd2.vm.provision "shell", inline: "curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -v 13.2.20"
    # Use chef provisioning
    etcd2.vm.provision "chef_zero" do |chef|
      # Specify the local paths where Chef data is stored
      chef.cookbooks_path = "cookbooks"
      #chef.data_bags_path = "data_bags"
      chef.nodes_path = "cookbooks/nodes"
      #chef.roles_path = "roles"
  
      # Add a recipe
      chef.add_recipe "install_etcd"
  
      # Or maybe a role
      #chef.add_role "web"
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
    # config.vm.synced_folder "vagrant/chef-repo", "/home/ubuntu/chef-repo"
    # Install Chef-client inside Vbox guest VM
    etcd3.vm.provision "shell", inline: "curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -v 13.2.20"
    # Use chef provisioning
    etcd3.vm.provision "chef_zero" do |chef|
      # Specify the local paths where Chef data is stored
      chef.cookbooks_path = "cookbooks"
      #chef.data_bags_path = "data_bags"
      chef.nodes_path = "cookbooks/nodes"
      #chef.roles_path = "roles"
  
      # Add a recipe
      chef.add_recipe "install_etcd"
  
      # Or maybe a role
      #chef.add_role "web"
    end
  end

end

