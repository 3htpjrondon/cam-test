#
# Cookbook Name:: oracle_mysql
# Resource:: harden
#
# Copyright IBM Corp. 2017, 2018
#
actions :set, :change
default_action :set

property :password, :kind_of => String, :default => node['mysql']['root_password']
property :service_name, :kind_of => String, :default => node['mysql']['service_name']
property :log_file, :kind_of => String, :default => node['mysql']['config']['log_file']
property :version, :kind_of => String, :default => node['mysql']['version']
property :data_dir, :kind_of => String, :default => node['mysql']['config']['data_dir']
property :new_password, :kind_of => String, :default => node['mysql']['root_password']

attr_accessor :mysql_installed
