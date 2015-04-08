{% from "jenkins/map.jinja" import jenkins, deploy with context %}

{% if jenkins.jobs.repo_location %}
{{ jenkins.jobs.repo_location }}:
  git.latest:
    - rev: master
    - target: /srv/jenkins/jobs/
    - force: True
    - makedirs: True
{% endif %}
