#
# Cookbook Name:: tomcat
# Resource:: keystore.rb
#
# Copyright IBM Corp. 2017, 2018
#
actions :create
default_action :create

# <> Java version to install. Should match platform-specific version, e.g. 1.8.0 for openjdk
property :java_home, :kind_of => String, :default => '/usr/java'

# <> Vendor, aka IBM, Oracle, 'platform' openjdk (e.g. rpm in RHEL yum repo)
property :java_vendor, :kind_of => String, :default => 'openjdk'

# <> Owner
property :owner, :kind_of => String, :default => nil

# <> Group of owner
property :group, :kind_of => String, :default => nil

# <> Keystore file name
property :keystore, :kind_of => String, :default => nil

# <> Keystore password
property :keystore_pass, :kind_of => String, :default => nil

# <> Keystore type
property :keystore_type, :kind_of => String, :default => 'JKS'

# <> Keystore algorithm
property :keystore_alg, :kind_of => String, :default => 'RSA'

# <> Self-signed certificate data
property :cert_data, :kind_of => Hash, :default => nil
