#########################################################################
########################################################
#	  Copyright IBM Corp. 2016, 2018
########################################################
# <> Create server recipe (create_server.rb)
# <> Create a new liberty server
#
#########################################################################

# Cookbook Name  - wasliberty
# Recipe         - create_server
#----------------------------------------------------------------------------------------------------------------------------------------------

# If the runas user field does not exist, then set to the wasadmin user
# If the runas_grep does not exist, then set to the install_grp
runas_grp = if node['was_liberty'].attribute?('runas_grp')
              node['was_liberty']['runas_grp'].to_s
            else
              node['was_liberty']['install_grp'].to_s
            end

runas_user = if node['was_liberty'].attribute?('runas_user')
               node['was_liberty']['runas_user'].to_s
             else
               node['was_liberty']['install_user'].to_s
             end

init_d = case node['platform_family']
         when 'aix'
           '/etc/rc.d/init.d'
         else
           '/etc/init.d'
         end


# Set the profile directory

Chef::Log.info("Setting permissions on the profile directory")

directory node['was_liberty']['wlp_user_dir'].to_s do
  action :create
  recursive true
  mode '775'
  owner runas_user.to_s
  group runas_grp.to_s
end

directory "#{node['was_liberty']['wlp_user_dir']}/servers" do
  action :create
  recursive true
  mode '775'
  owner runas_user.to_s
  group runas_grp.to_s
end

directory "#{node['was_liberty']['wlp_user_dir']}/shared" do
  action :create
  recursive true
  mode '775'
  owner runas_user.to_s
  group runas_grp.to_s
end

directory "#{node['was_liberty']['wlp_user_dir']}/shared/apps" do
  action :create
  recursive true
  mode '775'
  owner runas_user.to_s
  group runas_grp.to_s
end

directory "#{node['was_liberty']['wlp_user_dir']}/shared/config" do
  action :create
  recursive true
  mode '775'
  owner runas_user.to_s
  group runas_grp.to_s
end

directory "#{node['was_liberty']['wlp_user_dir']}/shared/resources" do
  action :create
  recursive true
  mode '775'
  owner runas_user.to_s
  group runas_grp.to_s
end

Chef::Log.info("-------------------------------------")
Chef::Log.info("Start executing recipe: create_server.rb")

# create liberty server
node['was_liberty']['liberty_servers'].each do |srv_index, v|
  server_name = v['name']
  next if srv_index['$INDEX'] && node['was_liberty']['skip_indexes'] == 'true'
  Chef::Log.info("start to create liberty server: #{server_name}")
  execute "create_server_#{server_name}" do
    command "#{node['was_liberty']['install_dir']}/bin/server create #{server_name}"
    user runas_user.to_s
    group runas_grp.to_s
    not_if { ::File.directory? "#{node['was_liberty']['wlp_user_dir']}/servers/#{server_name}" }
    action :run
  end

  template "#{init_d}/wlp-#{server_name}" do
    source "init.d.erb"
    mode '0755'
    owner "root"
    group "root"
    variables(
      :serverName => server_name.to_s,
      :cleanStart => true,
      :user => runas_user.to_s,
      :installDir => node['was_liberty']['install_dir'].to_s,
      :authBind => false,
      :skipUmask => false
    )
  end
  
  service "wlp-#{server_name}" do
    action :enable
    supports :restart => true, :start => true, :stop => true, :status => true
  end

end
