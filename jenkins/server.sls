{% from "jenkins/map.jinja" import jenkins, deploy with context %}
include:
  - .repo
  - .user
  - .ssh

jenkins_deps:
  pkg.installed:
    - pkgs:
      - git

jenkins:
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

