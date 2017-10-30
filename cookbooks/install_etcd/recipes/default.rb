# etcd recipe

# Run apt-get update on a schedule - once every 24 hours
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

# Install etcd package
package 'etcd'

# delete the default created config file
file '/etc/default/etcd' do
	action :delete
end


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