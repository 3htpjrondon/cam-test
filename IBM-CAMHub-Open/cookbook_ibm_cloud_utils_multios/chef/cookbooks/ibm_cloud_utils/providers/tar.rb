# encoding: UTF-8
########################################################
# Copyright IBM Corp. 2016, 2018
########################################################
#
# Cookbook Name:: ibm_cloud_utils
###############################################################################
require 'chef/resource/powershell_script'

action :tar do
    if RUBY_PLATFORM =~ /win|mingw/
        Chef::Log.debug("DEBUG: tar on Windows #{new_resource.target_tar} to #{new_resource.source}...")
        powershell_script 'tar with tar.exe from chef-client' do
            code <<-EOH
            $tarfilename = [System.IO.Path]::GetFullPath('#{new_resource.target_tar}')
            $tempTarget = '#{new_resource.source}'

            If ($tempTarget.endswith('*.*')){
                $target = $tempTarget.Replace('*.*', '')
                $cwd = [System.IO.Path]::GetFullPath($target)
                $targetfile = '*.*'
            }

            Else{
                $targetfile = [System.IO.Path]::GetFileName($tempTarget)
                $cwd = [System.IO.Path]::GetDirectoryName($tempTarget)
            }
            cd "$cwd"
            cmd /c 'c:\\opscode\\chef\\bin\\tar.exe' -cf "$tarfilename" "$targetfile"

            EOH
        end
    else
        Chef::Log.debug("DEBUG: tar on Unix #{new_resource.target_tar} to #{new_resource.source}...")
        execute 'tar files' do
            command "tar -cf #{new_resource.target_tar} #{new_resource.source}"
        end
    end
end
