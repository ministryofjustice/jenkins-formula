{% from "jenkins/map.jinja" import jenkins, deploy with context %}

jenkins-user:
  user.present:
    - name: jenkins
    - uid: 251
    - system: True
    - home: /srv/jenkins
    - shell: /bin/bash
    - makedirs: True
{% if jenkins.optional_groups %}
    - optional_groups: {{ jenkins.optional_groups|yaml }}
{% endif %}

/srv/jenkins/.ssh:
  file.directory:
    - user: jenkins
    - group: jenkins
    - mode: 700
    - require:
      - user: jenkins

{% if "privkey" in deploy.ssh and deploy.ssh.privkey %}
/srv/jenkins/.ssh/{{ deploy.ssh.key_type }}:
  file.managed:
    - user: jenkins
    - group: jenkins
    - mode: 600
    - contents_pillar: deploy:ssh:privkey
    - require:
      - user: jenkins
      - file: /srv/jenkins/.ssh
{% endif %}

{% if "pubkey" in deploy.ssh and deploy.ssh.pubkey %}
/srv/jenkins/.ssh/authorized_keys:
  file.managed:
    - user: jenkins
    - group: jenkins
    - mode: 640
    - contents_pillar: deploy:ssh:pubkey
    - require:
      - user: jenkins
      - file: /srv/jenkins/.ssh
{% endif %}

ssh_github_jenkins:
  ssh_known_hosts:
    - present
    - name: github.com
    - user: jenkins
    - fingerprint: {{ salt['pillar.get']('github_ssh_fingerprint', '16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48') }}
    - require:
      - user: jenkins
      - file: /srv/jenkins/.ssh

