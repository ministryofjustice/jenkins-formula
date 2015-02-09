{% from "jenkins/map.jinja" import jenkins with context %}

{% for plugin, version in jenkins.plugins.items() %}
{{plugin}}:
  jenkins.plugin_installed:
    - name: {{plugin}}
{% if version %}
    - version: '{{version}}'
    - require:
      - service: jenkins
{% endif %}
{% endfor %}
