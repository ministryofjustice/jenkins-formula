jenkins
=======

jenkins module that:
 - Adds the upstream Jenkins apt package repo and signing key
 - installs jenkins
 - preconfigures github server key
 - (optionally) adds ssh deploy key to jenkins user
 - configures git to have a user & email info
 - sets up vhost for jenkins using nginx
 - installs plugins

optional modules that:
 - manages jobs held in an external git repo
 - sets up a slave with the slave state file
 - set up a /etc/sudoers.d/jenkins with the sudoersd state file

pillar example
--------------
It's good to extend `client_max_body_size` for nginx to allow for plugins installation. Note that if you are behing ssl termination layer than `client_max_body_size` will need to be updated there as well.


```yaml


jenkins:
  git:
    email: jenkins@localhost
    name: Your Jenkins
  optional_groups:
    - docker
  plugins:
    - git
    - hipchat
  jobs:
    - repo_location: 'https://github.com/ministryofjustice/jenkins-jobs.git'

apps:
  jenkins:
    nginx:
      client_max_body_size: 1M

#for load balancer
nginx:
  http_core_module_config:
    client_max_body_size: 1M

#only if you need to overwrite default
github_ssh_fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48


deploy:
  ssh:
    key_type: id_rsa
    privkey: |
      -----BEGIN RSA PRIVATE KEY-----
      your key
      -----END RSA PRIVATE KEY-----


```
