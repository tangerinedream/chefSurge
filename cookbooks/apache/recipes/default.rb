#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
## Add resource to Recipe
package "apache2" do
	action :install
end

service "apache2" do
	action [ :enable, :start ]
end

### GHS
# execute is like shelling-out
execute "a2dissite default" do
  only_if do
    File.symlink?("/etc/apache2/sites-enabled/000-default")
  end
  notifies :restart, "service[apache2]"
end

# node in this case is a hash(table), not a keyword
node['apache']['sites'].each do |site_name, site_data|
	document_root = "/srv/apache/#{site_name}"
### Here, we are generating the virtual site file using a Template.
	template "/etc/apache2/sites-available/#{site_name}" do
###		custom.erb is in the template directory, and is the shell for the virtual site file, customized per below
		source "custom.erb"
		mode "0644"
		# variables is a method, hence the parens
		variables(
			:document_root => document_root,
			:port => site_data['port']
		)
		notifies :restart, "service[apache2]"
	end
	execute "a2ensite #{site_name}" do
		not_if do
###			Don't do the execute if this link exists
			File.symlink?("/etc/apache2/sites-enabled/#{site_name}")
		end
		notifies :restart, "service[apache2]"
	end
	directory document_root do
		mode "0755"
###		recursive means mkdir -p
		recursive true
	end
### Here, we are generating the index.html file using a Template.
	template "#{document_root}/index.html" do
###		index.html.erb is in the template directory. Like a .jsp, template will merge and generate the html page
		source "index.html.erb"
		mode "0644"
		variables(
			:site_name => site_name,
			:port => site_data['port']
		)
	end
end

### We used this before learning about templates and (index.html.)erb files
## cookbook_file "/var/www/index.html" do
## 	source "index.html"
## 	mode "0644"
## end
