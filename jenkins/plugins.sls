{% from "jenkins/map.jinja" import jenkins with context %}

{# test if jenkins_system_user_token grain exists and set it to None if it doesn't #}
{% set jenkins_system_user_token = salt['grains.get']('jenkins_system_user_token', None) %}

{% for plugin in jenkins.plugins %}
{{plugin}}:
  jenkins.plugin_installed:
    - name: {{plugin}}
{% if jenkins_system_user_token != None %}
    - jenkins_url: "http://SYSTEM:{{jenkins_system_user_token}}@localhost:8877"
{% endif %}
    - require:
      - cmd: /srv/jenkins/update-available-plugins.sh
      - service: jenkins
    - watch_in:
      - cmd: jenkins-safe-restart
{% endfor %}

curl:
  pkg.installed

jenkins-safe-restart:
  cmd.wait:
{% if jenkins_system_user_token != None %}
    - name: curl -X POST "http://SYSTEM:{{jenkins_system_user_token}}@{{jenkins.nginx.upstream}}/safeRestart"
{% else %}
    - name: curl -X POST "http://{{jenkins.nginx.upstream}}/safeRestart"
{% endif %}
    - require:
      - pkg: curl
