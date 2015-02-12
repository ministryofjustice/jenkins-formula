jenkins_deps:
  pkg.installed:
    - pkgs:
      - git

/srv/jenkins/.gitconfig:
  file.managed:
    - user: jenkins
    - group: jenkins
    - mode: 644
    - source: salt://jenkins/templates/gitconfig
    - template: jinja
    - require:
      - user: jenkins
    - require:
      - pkg: jenkins_deps

