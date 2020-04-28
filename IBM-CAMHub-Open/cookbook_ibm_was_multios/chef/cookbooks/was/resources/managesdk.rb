#
# Cookbook Name:: was
# Provider:: was_managesdk
#
# Copyright IBM Corp. 2017, 2018
#
actions :setCommandDefault, :setNewProfileDefault
default_action :setCommandDefault

property :java_version, :kind_of => String, :default => node['was']['java_version']
property :install_dir, :kind_of => String, :default => node['was']['install_dir']
property :admin_user, :kind_of => String, :default => node['was']['os_users']['was']['name']

attr_accessor :sdkCommandDefault
attr_accessor :sdkNewProfileDefault
