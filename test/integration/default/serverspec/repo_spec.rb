require 'serverspec'
require 'net/http'
require 'uri'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

describe "jenkins repo setup" do

  describe file("/var/tmp/jenkins-ci.org.key") do
    it {should be_file}
    it {should be_owned_by "root"}
    it {should be_grouped_into "root"}
  end

  describe file("/etc/apt/sources.list.d/jenkins.list") do
    it {should be_file}
    it {should be_owned_by "root"}
    it {should be_grouped_into "root"}
    its(:content) { should match /deb http:\/\/pkg\.jenkins-ci\.org\/debian binary\//}
  end

end
