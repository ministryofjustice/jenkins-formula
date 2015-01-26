{% from "jenkins/map.jinja" import jenkins, deploy with context %}
include:
  - .repo
  - nginx
  - logstash.beaver

jenkins_deps:
  pkg.installed:
    - pkgs:
      - git


jenkins:
  user.present:
    - home: /srv/jenkins
    - shell: /bin/bash
    - makedirs: True
{% if jenkins.optional_groups %}
    - optional_groups: {{ jenkins.optional_groups|yaml }}
{% endif %}
  pkg:
    - installed
    - require:
      - user: jenkins
      - file: /etc/default/jenkins
    - watch_in:
      - service: jenkins
  service:
    - running
    - enable: True


/srv/jenkins/.gitconfig:
  file.managed:
    - user: jenkins
    - group: jenkins
    - mode: 644
    - source: salt://jenkins/templates/gitconfig
    - template: jinja
    - require:
      - user: jenkins
    - require:
      - pkg: jenkins_deps


/etc/default/jenkins:
  file.managed:
    - user: jenkins
    - group: jenkins
    - mode: 644
    - source: salt://jenkins/templates/default/jenkins
    - template: jinja
    - require:
      - user: jenkins
    - require:
      - pkg: jenkins_deps
    - watch_in:
      - service: jenkins


/srv/jenkins/update-available-plugins.sh:
  file:
    - managed
    - source: salt://jenkins/files/update-available-plugins.sh
    - user: jenkins
    - mode: 755
    - require:
      - user: jenkins
  cmd:
    - wait
    - cwd: /tmp
    - user: jenkins
    - watch:
      - service: jenkins
    - require:
      - user: jenkins
      - file: /srv/jenkins/update-available-plugins.sh


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


ssh_github_jenkins:
  ssh_known_hosts:
    - present
    - name: github.com
    - user: jenkins
    - fingerprint: {{ salt['pillar.get']('github_ssh_fingerprint', '16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48') }}
    - require:
      - user: jenkins
      - file: /srv/jenkins/.ssh

/etc/nginx/conf.d/jenkins.conf:
  file.managed:
    - template: jinja
    - source: salt://jenkins/templates/default/jenkins-proxy.conf
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: nginx
    - require:
      - user: jenkins
      - pkg: nginx

{% from 'logstash/lib.sls' import logship with context %}
{{ logship('jenkins-access', '/var/log/nginx/jenkins.access.json', 'nginx', ['nginx', 'jenkins', 'access'], 'rawjson') }}
{{ logship('jenkins-error',  '/var/log/nginx/jenkins.error.log', 'nginx', ['nginx', 'jenkins', 'error'], 'json') }}

{{ logship('jenkins',  '/var/log/jenkins/jenkins.log', 'jenkins', ['jenkins', ], 'json') }}
