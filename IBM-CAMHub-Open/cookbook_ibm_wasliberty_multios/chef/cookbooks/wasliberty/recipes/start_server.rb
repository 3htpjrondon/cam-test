#########################################################################
########################################################
#	  Copyright IBM Corp. 2016, 2018
########################################################
# <> Start server recipe (start_server.rb)
# <> Start server recipe, start liberty servers
#
#########################################################################

# Cookbook Name  - wasliberty
# Recipe         - start_server
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

start_servers = if !node['was_liberty']['start_servers'].empty?
                  node['was_liberty']['start_servers'].split(/[\s,]+/).reject(&:empty?)
                else
                  Dir.entries("#{node['was_liberty']['wlp_user_dir']}/servers/").reject { |f| f.start_with?(".") }
                end

log "start_servers" do
  message "****** Starting servers: #{start_servers} ******"
  level :info
end

# start liberty servers
node['was_liberty']['liberty_servers'].each do |srv_index, v|

  server_name = v['name']
  next unless start_servers.include?(server_name)

  log "start_server" do
    message "Server start: <#{server_name}>"
    level :info
  end

  jvm_opts_file = "#{node['was_liberty']['wlp_user_dir']}/servers/#{server_name}/jvm.options"
  jvm_params = node['was_liberty']['liberty_servers'][srv_index]['jvm_params']

  template jvm_opts_file do
    source 'jvm.options.erb'
    variables(
      :jvm_options => jvm_params.split
    )
    owner runas_user
    group runas_grp
  end

  wasliberty_wl_server server_name do
    action :start
    user runas_user
    timeout node['was_liberty']['liberty_servers'][srv_index]['timeout']
    install_dir node['was_liberty']['install_dir']
    force_restart node['was_liberty']['force_restart']
    jvm_options jvm_params
  end
end
