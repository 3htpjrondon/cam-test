########################################################
# Copyright IBM Corp. 2016, 2018
########################################################
#

actions :create, :remove, :enable, :disable
default_action :create

attribute :swapfile, :kind_of => String, :default => '/swapfile.swp'
attribute :size, :kind_of => String
attribute :label, :kind_of => String
attribute :force, :kind_of => [TrueClass, FalseClass], :default => false
