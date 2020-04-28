#
# Cookbook Name:: db2
# Provider:: db2_service
#
# Copyright IBM Corp. 2017, 2018
#
actions :stop_instance, :start_instance, :stop_das, :start_das
default_action :start_instance

property :instance_username, :kind_of => String, :default => nil
property :log_dir, :kind_of => String, :default => node['ibm']['log_dir']
property :db2_install_dir, :kind_of => String, :default => node['db2']['install_dir']
property :das_user, :kind_of => String, :default => node['db2']['das_username']

attr_accessor :db2_instance_stopped
attr_accessor :db2_instance_started
attr_accessor :db2_das_stopped
attr_accessor :db2_das_started
attr_accessor :db2_list_instances