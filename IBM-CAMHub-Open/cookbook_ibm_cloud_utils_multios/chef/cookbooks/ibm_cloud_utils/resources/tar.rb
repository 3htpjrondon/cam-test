# encoding: UTF-8
########################################################
# Copyright IBM Corp. 2016, 2018
########################################################
#
# Cookbook Name:: ibm_cloud_utils
###############################################################################
actions :tar
default_action :tar

attribute :source, :kind_of => String
attribute :target_tar, :kind_of => String

attr_accessor :exists
