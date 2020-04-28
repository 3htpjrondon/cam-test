#
# Cookbook Name:: tomcat
# Resource:: link_dirs.rb
#
# Copyright IBM Corp. 2017, 2018
#
actions :link
default_action :link

# <> Destination directory
property :dest_dir, :kind_of => String, :default => nil

# <> Source directory
property :source_dir, :kind_of => String, :default => nil

# <> Owner
property :owner, :kind_of => String, :default => nil

# <> Group of owner
property :group, :kind_of => String, :default => nil

# <> Mode of created directory
property :mode, :kind_of => String, :default => '0750'
