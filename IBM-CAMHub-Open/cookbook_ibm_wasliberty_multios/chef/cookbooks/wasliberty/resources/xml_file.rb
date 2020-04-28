########################################################
# Copyright IBM Corp. 2016, 2018
########################################################

default_action :add_element

property :source, :kind_of => String, :name_attribute => true
property :search_path, :kind_of => String, :required => true
property :content, :kind_of => String, :default => nil
property :node_attrs, :kind_of => Hash, :default => {}
