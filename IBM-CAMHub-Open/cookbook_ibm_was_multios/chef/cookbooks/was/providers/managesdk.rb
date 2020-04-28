#
# Cookbook Name:: was
# Provider:: was_managesdk
#
# Copyright IBM Corp. 2017, 2019
#
include WASHelper

action :setCommandDefault do
  if @current_resource.sdkCommandDefault
    Chef::Log.info "#{@new_resource} already exists - nothing to do."
  else
    converge_by("setCommandDefault #{@new_resource}") do
      case node['os']
      when 'linux'
        sdk_version = getsdkversion
        log "sdk_version: #{sdk_version}"
        cmd = "#{env_variables} #{new_resource.install_dir}/bin/managesdk.sh -setCommandDefault -sdkname #{sdk_version}"
        log cmd
        cmd_out = run_shell_cmd(cmd, new_resource.admin_user)
        log cmd_out.stdout
      end
    end
  end
end

action :setNewProfileDefault do
  if @current_resource.sdkNewProfileDefault
    Chef::Log.info "#{@new_resource} already exists - nothing to do."
  else
    converge_by("setNewProfileDefault #{@new_resource}") do
      case node['os']
      when 'linux'
        sdk_version = getsdkversion
        log "sdk_version: #{sdk_version}"
        cmd = "#{env_variables} #{new_resource.install_dir}/bin/managesdk.sh -setNewProfileDefault -sdkname #{sdk_version}"
        log cmd
        cmd_out = run_shell_cmd(cmd, new_resource.admin_user)
        log cmd_out.stdout
      end
    end
  end
end

#Override Load Current Resource
def load_current_resource
  # CHEF 12 @current_resource = Chef::Resource::WasManagesdk.new(@new_resource.name)
  @current_resource = Chef::Resource.resource_for_node(:was_managesdk, node).new(@new_resource.name)
  #A common step is to load the current_resource instance variables with what is established in the new_resource.
  #What is passed into new_resouce via our recipes, is not automatically passed to our current_resource.
  #Get current state
  @current_resource.sdkNewProfileDefault = check_sdk?('getNewProfileDefault')
  @current_resource.sdkCommandDefault = check_sdk?('getCommandDefault')
end

def getsdkversion
  case node['os']
  when 'linux'
    java_v = new_resource.java_version.split('.')[0] + '.' + new_resource.java_version.split('.')[1]
    Chef::Log.debug("#{new_resource.install_dir}/bin/managesdk.sh -listAvailable  | grep #{java_v}")
    cmd_available = "#{env_variables} #{new_resource.install_dir}/bin/managesdk.sh -listAvailable | grep #{java_v}"
    cmd_available_out = run_shell_cmd(cmd_available, new_resource.admin_user)
    sdk_version = cmd_available_out.stdout.split[-1]
    Chef::Log.info("sdk_version: #{sdk_version}")
  end
end

def check_sdk?(option)
  case node['os']
  when 'linux'
    sdk_version = getsdkversion
    cmd_check_sdk = "#{env_variables} #{new_resource.install_dir}/bin/managesdk.sh -#{option}"
  end
  cmd = run_shell_cmd(cmd_check_sdk, @new_resource.admin_user)
  cmd.stderr.empty? && /#{sdk_version}/.match(cmd.stdout)
end

def env_variables
  # Workaround for a problem introduced by https://www-01.ibm.com/support/docview.wss?uid=swg1PH09335
  "USER_INSTALL_ROOT='#{new_resource.install_dir}'" if node['was']['version'] == '9.0.5.0'
end
