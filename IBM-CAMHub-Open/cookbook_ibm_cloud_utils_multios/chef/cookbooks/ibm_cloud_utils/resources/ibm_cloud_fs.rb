########################################################
# Copyright IBM Corp. 2016, 2018
########################################################
#

actions :create, :remove, :enable, :disable
default_action :create

attribute :device, :kind_of => String
attribute :fstype, :kind_of => String
attribute :label, :kind_of => String
attribute :mountpoint, :kind_of => String
attribute :options, :kind_of => String, :default => 'defaults'
attribute :force, :kind_of => [TrueClass, FalseClass], :default => false
