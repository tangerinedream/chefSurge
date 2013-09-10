#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#<search>(<index>, <query>) for each from the array of hashes, do something
search(:groups, "*:*").each do |group_data|
	group group_data['id'] do
		gid group_data['gid']
		members group_data['members']
	end
end

