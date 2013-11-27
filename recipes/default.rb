#
# Cookbook Name:: mecab
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

version = node["mecab"]["version"]

remote_file "#{Chef::Config[:file_cache_path]}/mecab-#{version}.tar.gz" do
  source "http://mecab.googlecode.com/files/mecab-#{version}.tar.gz"
  checksum node['mecab']['checksum']
  mode "0644"
  not_if { ::File.exists?("/usr/local/bin/mecab") }
end

bash "build_and_install_mecab" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf mecab-#{version}.tar.gz
    (cd mecab-#{version} && ./configure #{node["mecab"]["configure_options"]})
    (cd mecab-#{version} && make && make check && make install)
  EOH
  not_if { ::File.exists?("/usr/local/bin/mecab") }
end

include_recipe "mecab::ipadic"