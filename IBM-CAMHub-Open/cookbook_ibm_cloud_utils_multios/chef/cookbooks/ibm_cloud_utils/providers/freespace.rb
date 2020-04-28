# encoding: UTF-8
########################################################
# Copyright IBM Corp. 2016, 2018
########################################################
#
# Cookbook Name:: ibm_cloud_utils
###############################################################################
include IBM::IBMHelper

action :check do
  IBM::IBMHelper.check_free_space(node, new_resource.path, new_resource.required_space, new_resource.continue, new_resource.error_message)
end
