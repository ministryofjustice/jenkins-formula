{% from "jenkins/map.jinja" import jenkins, deploy with context %}

{% if jenkins.jobs_repo %}
/tmp/{{ jenkins.jobs_repo|yaml }}:
  file.directory:
    - user: jenkins
    - group: jenkins
    - mode: 700
    - require:
      - user: jenkins
{% endif %}
