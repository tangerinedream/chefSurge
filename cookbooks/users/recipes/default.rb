#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
decrypted = Chef::EncryptedDataBagItem.load("passwords", "userlist")

#<search>(<index>, <query>) for each from the array of hashes, do something
search(:users, "*:*").each do |user_data|
	user user_data['id'] do
		comment user_data['comment']
		uid user_data['uid']
		gid user_data['gid']
		home user_data['home']
		shell user_data['shell']
		password decrypted[user_data['id']]
	end
end

# group cookbook in users recipe directory
# brings group cookbook into this cookbook at this time
include_recipe "users::groups"
