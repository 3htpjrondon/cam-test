#
# Cookbook Name:: was
# Provider:: was_webserver
#
# Copyright IBM Corp. 2017, 2018
#
actions :create
default_action :create

property :profile_type, :kind_of => String, :default => nil
property :profile_path, :kind_of => String, :default => nil
property :admin_user, :kind_of => String, :default => nil
property :admin_pwd, :kind_of => String, :default => nil # ~password_checker
property :os_user, :kind_of => String, :default => nil
property :webserver_name, :kind_of => String, :default => nil


attr_accessor :webserver_created
