#
# Cookbook Name:: tomcat
# Resource:: java.rb
#
# Copyright IBM Corp. 2017, 2018
#

default_action :upgrade

# <> Java version to install. Should match platform-specific version, e.g. 1.8.0 for openjdk
property :version, :kind_of => String, :default => nil

# <> Vendor, aka IBM, Oracle, 'platform' openjdk (e.g. rpm in RHEL yum repo)
property :vendor, :kind_of => String, :default => 'openjdk'

# <> SDK if 'true', JRE if 'false'
property :sdk, :kind_of => String, :default => 'false'

# <> Archive URI; not for openjdk
property :archive_url, :kind_of => String, :default => nil

# <> Installation directory (will be JAVA_HOME); not for openjdk
property :install_dir, :kind_of => String, :default => nil
