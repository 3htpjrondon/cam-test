#
# Cookbook Name:: was
# Provider:: was_setheapsize
#
# Copyright IBM Corp. 2017, 2018
#
actions :set_initial_heap_size, :set_maximum_heap_size
default_action :set_initial_heap_size

property :profile_type, :kind_of => String, :default => nil
property :profile_path, :kind_of => String, :default => nil
property :admin_user, :kind_of => String, :default => nil
property :admin_pwd, :kind_of => String, :default => nil # ~password_checker
property :os_user, :kind_of => String, :default => nil
property :property_name_initial, :kind_of => String, :default => 'initialHeapSize'
property :property_value_initial, :kind_of => String, :default => nil
property :property_name_maximum, :kind_of => String, :default => 'maximumHeapSize'
property :property_value_maximum, :kind_of => String, :default => nil
property :node_name, :kind_of => String, :default => nil
property :server_name, :kind_of => String, :default => nil

attr_accessor :initial_heap_size
attr_accessor :maximum_heap_size