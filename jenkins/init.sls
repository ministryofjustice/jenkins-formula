include:
  - repos
  - nginx
  - logstash.beaver
  - .server
  - .plugins

{% from 'logstash/lib.sls' import logship with context %}
{{ logship('jenkins-access', '/var/log/nginx/jenkins.access.json', 'nginx', ['nginx', 'jenkins', 'access'], 'rawjson') }}
{{ logship('jenkins-error',  '/var/log/nginx/jenkins.error.log', 'nginx', ['nginx', 'jenkins', 'error'], 'json') }}

{{ logship('jenkins',  '/var/log/jenkins/jenkins.log', 'jenkins', ['jenkins', ], 'json') }}
