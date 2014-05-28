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
It's good to extend client_max_body_size for nginx to allow for plugins installation


```yaml


jenkins:
  email: jenkins@localhost
  name: Your Jenkins


apps:
  nginx:
    client_max_body_size: 1M


github_ssh_fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48


deploy:
  ssh:
    key_type: id_rsa
    privkey: |
      -----BEGIN RSA PRIVATE KEY-----
      your key
      -----END RSA PRIVATE KEY-----


```

