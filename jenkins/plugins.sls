{% from "jenkins/map.jinja" import jenkins with context %}

{% for plugin in jenkins.plugins %}
{{plugin}}:
  jenkins.plugin_installed:
    - name: {{plugin}}
    - require:
      - cmd: /srv/jenkins/update-available-plugins.sh
      - service: jenkins
{% endfor %}
