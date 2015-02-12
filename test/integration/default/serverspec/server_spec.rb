require 'serverspec'
require 'net/http'
require 'uri'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

describe "jenkins server setup" do

  %w(git jenkins).each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end

  describe user("jenkins") do
    it { should exist }
    it { should have_home_directory "/srv/jenkins" }
    it { should have_login_shell "/bin/bash" }
    %w(jenkins).each do |g|
      it { should belong_to_group g }
    end
  end

  describe file("/etc/default/jenkins") do
    it {should be_file}
    it { should be_mode 644 }
    it {should be_owned_by "jenkins"}
    it {should be_grouped_into "jenkins"}
    its(:content) { should match /HTTP_PORT=8877/}
  end

  describe file("/srv/jenkins/.gitconfig") do
    it {should be_file}
    it { should be_mode 644 }
    it {should be_owned_by "jenkins"}
    it {should be_grouped_into "jenkins"}
  end

  describe file("/srv/jenkins/.ssh") do
    it {should be_directory}
    it { should be_mode 700 }
    it {should be_owned_by "jenkins"}
    it {should be_grouped_into "jenkins"}
  end

  describe file("/srv/jenkins/.ssh/known_hosts") do
    it {should be_file}
    it { should be_mode 644 }
    it {should be_owned_by "jenkins"}
    it {should be_grouped_into "jenkins"}
  end
end
