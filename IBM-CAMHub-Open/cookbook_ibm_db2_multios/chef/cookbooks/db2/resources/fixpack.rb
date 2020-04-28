#
# Cookbook Name:: db2
# Provider:: db2_fixpack
#
# Copyright IBM Corp. 2017, 2018
#
actions :install
default_action :install

property :fixpack, :kind_of => String, :default => node['db2']['fixpack']
property :log_dir, :kind_of => String, :default => node['ibm']['log_dir']
property :db2_install_dir, :kind_of => String, :default => node['db2']['install_dir']
property :das_user, :kind_of => String, :default => node['db2']['das_username']
property :fp_dir, :kind_of => String, :default => node['db2']['fp_dir']
property :db2_base_version, :kind_of => String, :default => node['db2']['version']


attr_accessor :db2_fp_installed