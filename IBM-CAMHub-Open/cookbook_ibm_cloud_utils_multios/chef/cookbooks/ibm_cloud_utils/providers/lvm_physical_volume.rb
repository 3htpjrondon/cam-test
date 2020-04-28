########################################################
# Copyright IBM Corp. 2016, 2018
########################################################
#

action :create do
  # This works on linux only
  if RUBY_PLATFORM.downcase.include?'linux'
    package 'lvm2'
    Chef::Log.info("Checking if the disk #{new_resource.disk} is attached")
    errormessage ||= "Make sure the disk #{new_resource.disk} is attached"
    if node['block_device'].attribute? new_resource.disk
      Chef::Log.info("creating PV using disk #{new_resource.disk}")
      execute "Create PV /dev/#{new_resource.disk}" do
        command "pvcreate /dev/#{new_resource.disk}"
        not_if "pvs | grep /dev/#{new_resource.disk}"
      end
      Chef::Log.info("PV created using disk #{new_resource.disk}")
    else
      Chef::Application.fatal!(errormessage, 13)
    end
  end
end
