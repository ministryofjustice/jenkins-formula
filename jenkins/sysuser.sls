{% from "jenkins/map.jinja" import jenkins, deploy with context %}

BeautifulSoup:
  pip.installed:
    - version: => 3.2.1
    - require:
      - pkg: python-pip

jenkins_system_user_api_captured:
  jenkins.ensure_system_user_apikey_grain:
  - require:
    - service: jenkins
    - pip: BeautifulSoup
