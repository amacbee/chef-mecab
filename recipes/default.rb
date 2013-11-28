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
  not_if "which mecab"
  source "http://mecab.googlecode.com/files/mecab-#{version}.tar.gz"
  checksum node['mecab']['checksum']
  mode "0644"
end

bash "build_and_install_mecab" do
  not_if "which mecab"
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf mecab-#{version}.tar.gz
    (cd mecab-#{version} && ./configure #{node["mecab"]["configure_options"]})
    (cd mecab-#{version} && make && make check && make install)
  EOH
end

include_recipe "mecab::ipadic"