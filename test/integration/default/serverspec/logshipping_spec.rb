require 'serverspec'
require 'net/http'
require 'uri'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

describe "logshipping setup" do

  describe service("beaver") do
    it{ should be_running }
  end

  describe file("/etc/beaver.conf") do
    it {should be_file}
    it {should be_owned_by "root"}
    it {should be_grouped_into "root"}
  end

  describe file("/etc/beaver.d/jenkins.conf") do
    it {should be_file}
    it {should be_owned_by "root"}
    it {should be_grouped_into "root"}
    its(:content) { should match /^\[\/var\/log\/jenkins\/jenkins\.log\]/}
    its(:content) { should match /format:\s*json/}
    its(:content) { should match /type:\s*jenkins/}
    its(:content) { should match /tags:\s*jenkins/}
  end

  describe file("/etc/beaver.d/jenkins-access.conf") do
    it {should be_file}
    it {should be_owned_by "root"}
    it {should be_grouped_into "root"}
    its(:content) { should match /^\[\/var\/log\/nginx\/jenkins\.access\.json\]/}
    its(:content) { should match /format:\s*rawjson/}
    its(:content) { should match /type:\s*nginx/}
    its(:content) { should match /tags:\s*nginx/}
  end

  describe file("/etc/beaver.d/jenkins-error.conf") do
    it {should be_file}
    it {should be_owned_by "root"}
    it {should be_grouped_into "root"}
    its(:content) { should match /^\[\/var\/log\/nginx\/jenkins\.error\.log\]/}
    its(:content) { should match /format:\s*json/}
    its(:content) { should match /type:\s*nginx/}
    its(:content) { should match /tags:\s*nginx/}
  end
end
