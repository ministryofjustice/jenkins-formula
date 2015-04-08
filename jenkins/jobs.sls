{% from "jenkins/map.jinja" import jenkins, deploy with context %}

{% if jenkins.jobs.repo_location %}
{{ jenkins.jobs.repo_location }}:
  git.latest:
    - rev: master
    - target: /srv/jenkins/jobs/
    - always_fetch: True
    - force: True
    - force_checkout: True
    - force_reset: True
    - makedirs: True
    - runas: jenkins
    - user: jenkins
{% endif %}
