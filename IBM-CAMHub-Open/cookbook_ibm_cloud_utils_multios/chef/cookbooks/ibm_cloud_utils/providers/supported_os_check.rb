# encoding: UTF-8
########################################################
# Copyright IBM Corp. 2016, 2018
########################################################
#
# Cookbook Name:: ibm_cloud_utils
###############################################################################
include IBM::IBMHelper

action :check do
  Chef::Log.debug('Check if pattern is supported on operating system of the vm')
  IBM::IBMHelper.verify_supported_os(node, new_resource.supported_os_list, new_resource.error_message)
end
