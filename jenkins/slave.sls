include:
  - .user
  - .ssh

{% if "pubkey" in deploy.ssh and deploy.ssh.pubkey %}
/srv/jenkins/.ssh/authorized_keys:
  file.managed:
    - user: jenkins
    - group: jenkins
    - mode: 640
    - contents_pillar: deploy:ssh:pubkey
    - require:
      - user: jenkins
      - file: /srv/jenkins/.ssh
{% endif %}

