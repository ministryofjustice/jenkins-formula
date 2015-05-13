{% from "jenkins/map.jinja" import jenkins, deploy with context %}

#
# This sls should be included when calling the jenkins API from the CLI, especially
# if it has auth enabled. It will try and get the SYSTEM user's token, cache it and
# make it a grain so it can be used in other sls files.
#

python-pip:
  pkg.installed

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
