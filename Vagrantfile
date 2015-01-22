# -*- ruby -*-

boxes = {
  '12.04' => 'hashicorp/precise64',
  '14.04' => 'puppetlabs/ubuntu-14.04-64-nocm',
}
the_box = boxes[ ENV.fetch('UBUNTU', '12.04') ]

Vagrant.configure("2") do |config|
  config.vm.define "jenkins" do |node|
    # mount salt required folders
    node.vm.synced_folder "vagrant/salt/root", "/srv/salt/"
    node.vm.synced_folder "vagrant/salt/pillar", "/srv/pillar/"
    node.vm.synced_folder "jenkins", "/srv/salt-formula/jenkins/"
    node.vm.synced_folder "../nginx-formula/nginx", "/srv/salt-formula/nginx/"
    node.vm.synced_folder "../logstash-formula/logstash", "/srv/salt-formula/logstash/"
    node.vm.synced_folder "../firewall-formula/firewall", "/srv/salt-formula/firewall/"
    node.vm.synced_folder "../bootstrap-formula/bootstrap", "/srv/salt-formula/bootstrap/"
    node.vm.synced_folder "../apparmor-formula/apparmor", "/srv/salt-formula/apparmor/"
    node.vm.synced_folder "../python-formula/python", "/srv/salt-formula/python/"
    node.vm.synced_folder "../repos-formula/repos", "/srv/salt-formula/repos/"

    node.vm.box = the_box
    node.vm.hostname = "jenkins"
    node.vm.network :private_network, ip: "192.168.33.100"

    node.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "1024"]
      v.name = "jenkins"
    end

    node.vm.provision :salt do |salt|
      salt.verbose = true
      salt.minion_config = "vagrant/salt/minion"
      salt.run_highstate = true
    end

    node.vm.provision :shell inline: "usermod -aG docker jenkins"
  end
end
