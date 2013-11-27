#
# Cookbook Name:: mecab
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# for mecab
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

# for mecab-ipadic
version = node["ipadic"]["version"]
remote_file "#{Chef::Config[:file_cache_path]}/mecab-ipadic-#{version}.tar.gz" do
  source "https://mecab.googlecode.com/files/mecab-ipadic-#{version}.tar.gz"
  checksum node['ipadic']['checksum']
  mode "0644"
  not_if { ::File.exists?("/usr/local/lib/mecab/dic/ipadic") }
end

bash "build_and_install_ipadic" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf mecab-ipadic-#{version}.tar.gz
    (cd mecab-ipadic-#{version} && ./configure #{node["ipadic"]["configure_options"]})
    (cd mecab-ipadic-#{version} && /usr/local/libexec/mecab/mecab-dict-index -f euc-jp -t utf-8)
    (cd mecab-ipadic-#{version} && make install)
  EOH
  not_if { ::File.exists?("/usr/local/lib/mecab/dic/ipadic") }
end