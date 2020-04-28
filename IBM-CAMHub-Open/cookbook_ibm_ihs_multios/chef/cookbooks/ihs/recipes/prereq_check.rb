# Cookbook Name:: ihs
# Recipe:: prereq_check
#
# Copyright IBM Corp. 2016, 2018
#

# <> Prerequisites recipe (prereq_check.rb)
# <> Verify required prerequisites, validate input

ibm_cloud_utils_hostsfile_update 'update_the_etc_hosts_file' do
  action :updateshosts
end

case node['platform_family']
when 'rhel'
  ibm_cloud_utils_enable_awsyumrepo 'enable_aws_extra_yumrepo' do
    action :enable
  end
end

# Validate requested IHS version
raise "Requested version #{node['ihs']['version']} format is invalid, expected <Release>.<Version>.<ML>.<FP>" if node['ihs']['version'].split('.').length != 4

if ihs_installed?
  # Get version of installed product
  inst_vers = ihs_installed_version
  log "IHS version #{inst_vers} is present"

  # Validate fixpack installation requests
  raise "Downgrade is not supported \(#{node['ihs']['version']} is lower than the installed version #{inst_vers}\)" if (node['ihs']['version'].split('.') <=> inst_vers.split('.')) < 0

  # Only allow fixpack installations
  raise "Upgrade is only supported at fixpack level, #{node['ihs']['version']} cannot be installed over #{inst_vers}" unless (node['ihs']['version'].split('.').slice(0, 3) <=> inst_vers.split('.').slice(0, 3)) == 0

  # Let them know we're upgrading
  log "Upgrading IHS from #{inst_vers} to #{node['ihs']['version']}" unless (node['ihs']['version'] <=> inst_vers) == 0
end

# Fail if install_dir exists but product is not installed
# 2237 - Remove directory if already exist and product not installed, we assume a previous failed install

if File.exist?(node['ihs']['install_dir'])
  directory node['ihs']['install_dir'] do
    recursive true
    action :delete
    not_if { ihs_installed? }
  end
end

# Validate bitness entry; v90 and up only
if node['ihs']['version'].split('.').first.to_i < 9
  raise "Select either '32' or '64' for bitness parameter" unless ['32', '64'].include? node['ihs']['features']['bitness']
end

# Validate legacy java version (v855 only, fp11 and higher)
if node['ihs']['version'].gsub(/\.\d+$/, '') == '8.5.5' && node['ihs']['version'].split('.').last.to_i >= 11
  raise "Invalid value \'#{node['ihs']['java']['legacy']}\' for node['ihs']['java']['legacy'], acceptable values are \'java6\' and \'java8\'" unless ['java6', 'java8'].include?(node['ihs']['java']['legacy'])
end

# System must have valid fqdn, or install will silently fail
raise 'Please ensure hostname -f returns a valid FQDN' if node['fqdn'].nil?

# Check Free Space on install_dir
ibm_cloud_utils_freespace 'check-freespace-install-dir-directory' do
  path node['ihs']['install_dir']
  required_space 500
  continue true
  action :check
  error_message "Please make sure you have at least 500MB free space under #{node['ihs']['install_dir']}"
  not_if { ihs_installed? }
end

# Check Free Space on temp_dir
ibm_cloud_utils_freespace 'check-freespace-temp-dir-directory' do
  path node['ibm']['temp_dir']
  required_space 500
  continue true
  action :check
  error_message "Please make sure you have at least 500MB free space under #{node['ibm']['temp_dir']}"
  not_if { ihs_installed? }
end
