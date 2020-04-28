
#
# Cookbook Name:: oracle_mysql
# Resource:: user
#
# Copyright IBM Corp. 2017, 2018
#
actions :create, :update, :remove
default_action :create

property :conn_password, :kind_of => String, :default => node['mysql']['root_password']
property :version, :kind_of => String, :default => node['mysql']['version']
property :data_dir, :kind_of => String, :default => node['mysql']['config']['data_dir']
property :user_name, :kind_of => String, :default => node['mysql']['config']['databases']['database_1']['users']['user_1']['name']
property :password, :kind_of => String, :default => node['mysql']['config']['databases']['database_1']['users']['user_1']['password']

attr_accessor :mysql_installed
attr_accessor :user_exists
