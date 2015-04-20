{% from "jenkins/map.jinja" import jenkins, deploy with context %}

python-pip:
  pkg.installed


BeautifulSoup:
  pip.installed:
    - version: => 3.2.1
    - require:
      - pkg: python-pip


