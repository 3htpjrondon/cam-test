#
# Cookbook Name:: db2
# Provider:: db2_database
#
# Copyright IBM Corp. 2017, 2018
#
actions :create, :remove
default_action :create

property :db_name, :kind_of => String, :default => nil
property :db2_install_dir, :kind_of => String, :default => node['db2']['install_dir']
property :instance_username, :kind_of => String, :default => nil
property :instance_groupname, :kind_of => String, :default => nil
property :db_data_path, :kind_of => String, :default => nil
property :db_path, :kind_of => String, :default => ''
property :log_dir, :kind_of => String, :default => node['ibm']['log_dir']
property :pagesize, :kind_of => String, :default => ''
property :territory, :kind_of => String, :default => ''
property :codeset, :kind_of => String, :default => ''
property :db_collate, :kind_of => String, :default => ''
property :database_update, :kind_of => Hash, :default => {}
property :database_users, :kind_of => Hash, :default => {}
property :instance_key, :kind_of => String, :default => ''
property :database_key, :kind_of => String, :default => ''

attr_accessor :db2_database_created
attr_accessor :db2_instance_created
