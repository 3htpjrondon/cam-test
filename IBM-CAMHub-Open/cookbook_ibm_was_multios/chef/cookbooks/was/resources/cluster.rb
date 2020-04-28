#
# Cookbook Name:: was
# Provider:: was_cluster
#
# Copyright IBM Corp. 2017, 2018
#
actions :create, :start
default_action :create

property :profile_type, :kind_of => String, :default => nil
property :profile_path, :kind_of => String, :default => nil
property :admin_user, :kind_of => String, :default => nil
property :admin_pwd, :kind_of => String, :default => nil # ~password_checker
property :os_user, :kind_of => String, :default => nil
property :cluster_name, :kind_of => String, :default => nil


attr_accessor :cluster_created
attr_accessor :cluster_started