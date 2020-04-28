#
# Cookbook Name:: was
# Provider:: was_serverincluster
#
# Copyright IBM Corp. 2017, 2018
#
actions :create, :create_server_in_cluster
default_action :create

property :profile_type, :kind_of => String, :default => nil
property :profile_path, :kind_of => String, :default => nil
property :admin_user, :kind_of => String, :default => nil
property :admin_pwd, :kind_of => String, :default => nil # ~password_checker
property :os_user, :kind_of => String, :default => nil
property :server_name, :kind_of => String, :default => nil
property :node_name, :kind_of => String, :default => nil

attr_accessor :server_in_cluster_created
