{% from "jenkins/map.jinja" import jenkinsuser, deploy with context %}

jenkins:
  user.present:
    - home: /srv/jenkins
    - shell: /bin/bash
    - makedirs: True
{% if jenkinsuser.optional_groups %}
    - optional_groups: {{ jenkinsuser.optional_groups|yaml }}
{% endif %}

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
