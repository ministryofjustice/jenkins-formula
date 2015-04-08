{% from "jenkins/map.jinja" import jenkins with context %}

{% for plugin in jenkins.plugins %}
{{plugin}}:
  jenkins.plugin_installed:
    - name: {{plugin}}
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
    - name: curl -X POST http://{{jenkins.nginx.upstream}}/safeRestart
    - require:
      - pkg: curl
