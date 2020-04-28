#
# Cookbook Name:: was
# Provider:: was_nodes
#
# Copyright IBM Corp. 2017, 2018
#
actions :create_unmanaged
default_action :create_unmanaged

property :profile_type, :kind_of => String, :default => nil
property :profile_path, :kind_of => String, :default => nil
property :admin_user, :kind_of => String, :default => nil
property :admin_pwd, :kind_of => String, :default => nil # ~password_checker
property :os_user, :kind_of => String, :default => nil
property :node_name, :kind_of => String, :default => nil

attr_accessor :unmanaged_created