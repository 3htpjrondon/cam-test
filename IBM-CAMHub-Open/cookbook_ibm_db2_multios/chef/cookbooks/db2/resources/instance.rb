#
# Cookbook Name:: db2
# Provider:: db2_instance
#
# Copyright IBM Corp. 2017, 2018
#
actions :create, :remove
default_action :create

property :instance_prefix, :kind_of => String, :default => nil
property :db2_install_dir, :kind_of => String, :default => node['db2']['install_dir']
property :instance_type, :kind_of => String, :default => nil
property :instance_username, :kind_of => String, :default => nil
property :instance_groupname, :kind_of => String, :default => nil
property :instance_password, :kind_of => String, :default => nil
property :instance_dir, :kind_of => String, :default => ''
property :port, :kind_of => String, :default => nil
property :fenced_username, :kind_of => String, :default => nil
property :fenced_groupname, :kind_of => String, :default => nil
property :fenced_password, :kind_of => String, :default => nil
property :fcm_port, :kind_of => String, :default => nil
property :log_dir, :kind_of => String, :default => node['db2']['expand_area'] + '/log'
property :rsp_file_path, :kind_of => String, :default => node['db2']['expand_area'] + '/tmp'

attr_accessor :db2_instance_created