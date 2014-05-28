/var/tmp/jenkins-ci.org.key:
  file.managed:
    - source: salt://jenkins/files/jenkins-ci.org.key


jenkins-apt-key:
  cmd.run:
    - name: apt-key add /var/tmp/jenkins-ci.org.key
    - unless: apt-key list | grep '1024D/D50582E6'


jenkins-deb:
  pkgrepo.managed:
    - humanname: Jenkins CI repo
    - name: deb http://pkg.jenkins-ci.org/debian binary/
    - file: /etc/apt/sources.list.d/jenkins.list
    - require:
      - cmd: jenkins-apt-key
    - require_in:
      - pkg.*
