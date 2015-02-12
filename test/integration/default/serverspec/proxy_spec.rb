require 'serverspec'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

platform = os[:family]

describe "jenkins proxy setup" do
  state = {
    "ubuntu"  => {
      "pkg"   => "nginx-full",
      "version" => "1.4.6-1ubuntu3.precise",
      "svc"   => "nginx",
      "user"  => "nginx",
      "group" => "nginx"
    }
  }

  describe package(state[platform]["pkg"]) do
    it { should be_installed.with_version(state[platform]["version"]) }
  end

  describe service(state[platform]["svc"]) do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening }
  end

  describe file("/etc/nginx/conf.d/jenkins.conf") do
    it {should be_file}
    it {should be_owned_by "root"}
    it {should be_grouped_into "root"}
    its(:content) { should match /upstream\s+jenkins/ }
    its(:content) { should match /server\s+"localhost:8877/}
  end

end
