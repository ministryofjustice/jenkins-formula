jenkins
=======

jenkins module that:
 - installs jenkins
 - preconfigures github server key
 - adds ssh deploy key to jenkins user
 - configures git user & email
 - sets up vhost for jenkins
 - pulls in jenkins pkg repo configuration


pillar example
--------------
It's good to extend `client_max_body_size` for nginx to allow for plugins installation. Note that if you are behing ssl termination layer than `client_max_body_size` will need to be updated there as well.


```yaml


jenkins:
  email: jenkins@localhost
  name: Your Jenkins


apps:
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


extending jenkins
-----------------

Usually you will want you own set of packages pre-installed on jenkins.
To do so, just overwrite `jenkins/deps.sls` in your main `file_roots` folder.
See salt docs [file_roots](http://docs.saltstack.com/en/latest/ref/file_server/file_roots.html)
