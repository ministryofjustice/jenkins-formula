{% from "jenkins/map.jinja" import jenkins, deploy with context %}

{% if jenkins.jobs.repo_location %}
/tmp/{{ jenkins.jobs.repo_location }}:
  file.directory:
    - user: jenkins
    - group: jenkins
    - mode: 700
    - require:
      - user: jenkins
{% endif %}
