{% from "jenkins/map.jinja" import jenkins, deploy with context %}

#
# Check if there's any change in the jobs folder on a file that's tracked.
# If there is, then call revert-all, which does a checkout
#
check-modifications:
  cmd.run:
    - user: jenkins
    - name: git diff --exit-code --quiet || echo changed=true
    - cwd: /srv/jenkins/jobs/
    - stateful: True
    - watch_in:
      - cmd: revert-all

#
# Revert all changes by doing a checkout. It will only touch files (jobs)
# it knows about.
#
revert-all:
  cmd.wait:
    - user: jenkins
    - name: git checkout .
    - cwd: /srv/jenkins/jobs/
    - watch_in:
      - cmd: jenkins-safe-restart

#
# Get all the jobs from the jobs repo and put them into jenkins' jobs folder.
# Call the safe-reload only if something's changed
#
{% if jenkins.jobs.repo_location %}
{{ jenkins.jobs.repo_location }}:
  git.latest:
    - force: True
    - depth: 10
    - force_reset: True
    - force_checkout: True
    - rev: master
    - target: /srv/jenkins/jobs/
    - always_fetch: True
    - makedirs: True
    - runas: jenkins
    - user: jenkins
    - watch_in:
      - cmd: jenkins-safe-restart
{% endif %}
