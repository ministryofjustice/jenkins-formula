# -*- ruby -*-

boxes = {
  '12.04' => 'hashicorp/precise64',
  '14.04' => 'puppetlabs/ubuntu-14.04-64-nocm',
}
the_box = boxes[ ENV.fetch('UBUNTU', '14.04') ]
dynamic_dir = ['_modules', '_grains', '_renderers', '_returners', '_states']
dev_formula = ['jenkins','nginx','logstash','firewall','bootstrap','apparmor','python','repos','docker']

Vagrant.configure("2") do |config|
  config.vm.define "jenkins" do |node|
    # mount salt required folders
    # This loop takes care of dynamic modules states etc.
    # You need to vagrant provision when you create new states
    # thereafter the changes are synced
    dev_formula.each do |f|
      node.vm.synced_folder "../#{f}-formula/#{f}/", "/srv/salt/#{f}"
      dynamic_dir.each do |ddir|
        if File.directory?("../#{f}-formula/#{ddir}")
          node.vm.synced_folder "../#{f}-formula/#{ddir}/", "/srv/salt-dynamic/#{f}-#{ddir}"
          node.vm.provision :shell,
            inline: "mkdir -p /srv/salt/#{ddir} && for f in /srv/salt-dynamic/#{f}-#{ddir}/*; do ln -sf $f /srv/salt/#{ddir}; done"
        end
      end
    end
    node.vm.synced_folder "vagrant/salt/root", "/srv/salt/"
    node.vm.synced_folder "vagrant/salt/pillar", "/srv/pillar/"

    node.vm.box = the_box
    node.vm.hostname = "jenkins"
    node.vm.network :private_network, ip: "192.168.33.100"

    node.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "1024"]
      v.name = "jenkins"
    end

    node.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"] = "1024"
    end

    node.vm.provision :salt do |salt|
      salt.verbose = true
      salt.minion_config = "vagrant/salt/minion"
      salt.run_highstate = true
    end

    node.vm.provision :shell, inline: "usermod -aG docker jenkins"
  end
end
