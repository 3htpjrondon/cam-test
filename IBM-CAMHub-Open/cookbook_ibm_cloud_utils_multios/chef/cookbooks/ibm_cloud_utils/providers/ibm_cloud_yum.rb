# encoding: UTF-8
########################################################
# Copyright IBM Corp. 2016, 2018
########################################################
#
# Cookbook Name:: ibm_cloud_utils
###############################################################################
include Chef::Mixin::ShellOut

action :install do
  if @current_resource.exists == 'I'
    converge_by("Installing #{@new_resource.package_name}") do
      shell_out!("yum #{@new_resource.options} install #{@new_resource.package_name}.x86_64 #{@new_resource.package_name}.i686")
    end
  end
end

action :upgrade do
  if @current_resource.exists == 'U'
    converge_by("Updating #{@new_resource.package_name}") do
      shell_out!("yum #{expand_options(@new_resource.options)} update #{@new_resource.package_name}.x86_64 #{@new_resource.package_name}.i686")
    end
  end
end

action :purge do
  if @current_resource.exists
    converge_by("Removing #{@new_resource.package_name}") do
      shell_out!("yum #{expand_options(@new_resource.options)} erase #{@new_resource.package_name}.x86_64 #{@new_resource.package_name}.i686")
    end
  end
end

def load_current_resource
  # CHEF 12 @current_resource = Chef::Resource::IbmCloudUtilsIbmCloudYum.new(@new_resource.name)
  @current_resource = Chef::Resource.resource_for_node(:ibm_cloud_utils_ibm_cloud_yum, node).new(@new_resource.name)
  @current_resource.package_name(@new_resource.package_name)
  @current_resource.version(@new_resource.version)
  @current_resource.source(@new_resource.source)
  @current_resource.options(@new_resource.options)

  # Call yum to determine the installed package(s) information.
  i = shell_out!("yum -q list installed #{@new_resource.package_name}|grep -v Installed")
  if i.exitstatus != 0
    Chef::Log.debug("#{@new_resource.package_name} isn't installed. Installing.")
    @current_resource.exists = 'I'
  else
    @current_resource.exists = 'U'
  end

  # Call yum to determine the available package(s) information. Yum will return a non-zero exit code if the installed package is current.
  a = shell_out!("yum -q list available #{@new_resource.package_name}|grep -v Available")
  if a.exitstatus != 0
    Chef::Log.debug("An update to #{@new_resource.package_name} isn't available; it may be at the latest version or isn't in the repo.")
    return
  else
    @current_resource.exists = 'U'
  end
end
