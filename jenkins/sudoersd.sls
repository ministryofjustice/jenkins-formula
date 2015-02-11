sudo:
  pkg:
    - installed

jenkins-sudoersd:
  file:
    - name: /etc/sudoers.d/jenkins
    - managed
    - user: root
    - group: root
    - mode: 440
    - contents: "jenkins    ALL=(ALL) NOPASSWD: ALL"
