{% from "jenkins/map.jinja" import jenkins, deploy with context %}

BeautifulSoup:
  pip.installed:
    - version: => 3.2.1
    - require:
      - pkg: python-pip


execute_custom_grain:
  cmd.run:
  - user: jenkins
  - name: python /srv/salt/_grains/sysuser.py
  - stateful: True
  - require:
    - service: jenkins
    - pip: BeautifulSoup
