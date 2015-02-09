include:
  - nginx

/etc/nginx/conf.d/jenkins.conf:
  file.managed:
    - template: jinja
    - source: salt://jenkins/templates/default/jenkins-proxy.conf
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: nginx
    - require:
      - user: jenkins
      - pkg: nginx
