#
# Cookbook Name:: tomcat
# Resource:: install.rb
#
# Copyright IBM Corp. 2017, 2018
#
actions :install # ,:upgrade
default_action :install

# <> Tomcat archive full download path
property :package_path, :kind_of => String, :default => nil

# <> Tomcat version
property :version, :kind_of => String, :default => nil

# <> CATALINA_HOME
property :catalina_home, :kind_of => String, :default => nil

# <> CATALINA_BASE (location of default instance)
property :catalina_base, :kind_of => String, :default => nil

# <> User directories hash
# property :instance_dirs, :kind_of => Hash, :default => node['tomcat']['instance_dirs']

# <> Daemon user
property :owner, :kind_of => String, :default => 'tomcat'

# <> Daemon group
property :group, :kind_of => String, :default => 'tomcat'

# <> Service name
property :tomcat_service, :kind_of => String, :default => 'tomcat'

# <> Temp dir for unpacking files
property :expand_area, :kind_of => String, :default => node['tomcat']['expand_area']

# <> Vault name containing repository credentials
property :vault_name, :kind_of => String, :default => nil

# <> Vault encrypted item
property :vault_item, :kind_of => String, :default => nil

# <> Repo has self-signed certificate?
property :repo_self_signed_cert, :kind_of => String, :default => nil
