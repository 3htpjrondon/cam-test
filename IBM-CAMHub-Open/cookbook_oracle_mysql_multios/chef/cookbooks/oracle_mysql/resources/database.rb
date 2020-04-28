
#
# Cookbook Name:: oracle_mysql
# Resource:: database
#
# Copyright IBM Corp. 2017, 2018
#
actions :create, :update, :remove
default_action :create

property :conn_password, :kind_of => String, :default => node['mysql']['root_password']
property :version, :kind_of => String, :default => node['mysql']['version']
property :data_dir, :kind_of => String, :default => node['mysql']['config']['data_dir']
property :db_name, :kind_of => String, :default => node['mysql']['config']['databases']['database_1']['database_name']

attr_accessor :mysql_installed
attr_accessor :database_exists
