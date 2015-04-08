{% from "jenkins/map.jinja" import jenkins, deploy with context %}

/tmp/LALA:
  file.directory:
    - user: jenkins
    - group: jenkins
    - mode: 700
    - require:
      - user: jenkins

