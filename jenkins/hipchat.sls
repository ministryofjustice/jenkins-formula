{% from "jenkins/map.jinja" import jenkins with context %}
{% if jenkins.hipchat %}
/srv/jenkins/jenkins.plugins.hipchat.HipChatNotifier.xml:
  file.managed:
    - user: jenkins
    - group: jenkins
    - mode: 644
    - source: salt://jenkins/templates/jenkins.plugins.hipchat.HipChatNotifier.xml
    - template: jinja
    - require:
      - user: jenkins
{% else %}
/srv/jenkins/jenkins.plugins.hipchat.HipChatNotifier.xml:
  file.absent
{% endif %}
