# encoding: UTF-8
########################################################
# Copyright IBM Corp. 2016, 2018
########################################################
#
# Cookbook Name:: ibm_cloud_utils
###############################################################################

action :check do
  Chef::Log.debug('Check Memory Allocated')
  Chef::Log.debug("Memory Found: #{node['memory']['total']}")
  Chef::Log.debug("Memory we need: #{new_resource.required}")
  errormessage ||= "Memory Allocation does not meet the minimum requirement of #{new_resource.required} MBs available!"
  Chef::Application.fatal!(errormessage, 7176) if node['memory']['total'].sub(/kb/i, '').to_i < new_resource.required.to_i * 1024 && !new_resource.continue
  Chef::Log.warn(errormessage) if node['memory']['total'].to_i < new_resource.required.to_i * 1024 && new_resource.continue
end
