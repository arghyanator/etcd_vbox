# etcd recipe

# Run apt-get update on a schedule - once every 24 hours
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

# Install etcd packages
package 'etcd'
package 'python-etcd'

#Stop the etcd service
service 'etcd' do
  action :stop
end

# delete the default created config file
file '/etc/default/etcd' do
	action :delete
end

#Delete the default database files
directory '/var/lib/etcd' do
  recursive true
  action :delete
end

#Recreate the /var/lib/etcd directory
directory '/var/lib/etcd' do
  owner 'etcd'
  group 'etcd'
  mode '0777'
  action :create
end

#Recreate the /var/lib/etcd/default directory
directory '/var/lib/etcd/default' do
  owner 'etcd'
  group 'etcd'
  mode '0755'
  action :create
end


# Set Node Hostname and IP address variables using ruby block
ruby_block "sethostandip" do
    block do
        Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)      
        command = 'hostname'
        command_out = shell_out(command)
        node.set['hostname'] = command_out.stdout
        command2 = 'hostname -I |awk \'{printf"%s", $2}\''
        command2_out = shell_out(command2)
        node.set['ip'] = command2_out.stdout
    end
    action :create
end

# Generate UUID for etcd cluster ID
cluster_uuid = UUIDTools::UUID.random_create.to_s 

template '/etc/default/etcd' do
	source 'etcd_conf.erb'
	variables(
		lazy { 
			{
				:etcdhostname => node['hostname'],
				:etcdipaddress => node['ip']
			}
		}
	)
	owner 'root'
	group 'root'
	mode '0644'
	action :create
	notifies :restart, 'service[etcd]', :immediately
end

service 'etcd' do
  action :nothing
end

cookbook_file '/tmp/check_etcd.sh' do
	source 'check_etcd.sh'
	owner 'root'
	group 'root'
	mode '0755'
	action :create
end

#Run script to check etcd status and change startup file for etcd after inital config
bash 'run_check_etcd' do
  cwd '/tmp'
  user 'root'
  group 'root'
  code <<-EOH
    /usr/bin/at now +5 minutes -f /tmp/check_etcd.sh
  EOH
end