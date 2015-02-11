{% from "jenkins/map.jinja" import jenkins, deploy with context %}

include:
  - .user
  - .ssh
