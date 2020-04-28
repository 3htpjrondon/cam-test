# encoding: UTF-8
########################################################
# Copyright IBM Corp. 2016, 2018
########################################################
#
# Cookbook Name:: ibm_cloud_sysctl
###############################################################################
actions :apply, :remove
default_action :apply

attribute :key, :kind_of => String, :required => true
attribute :value, :kind_of => String
attribute :sysctl_file, :kind_of => String, :default => '/etc/sysctl.d/99-ibm_cloud_sysctl.conf'
