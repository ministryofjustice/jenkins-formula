## Version 1.x.x

* Add plugins.sls so you can specify plugins to install in the pillar.
* Add safe restart on plugin install/change
* Add jobs.sls so you can manage jenkins jobs via salt
* Add sysuser sls to cache the token for jenkins's SYSTEM user

## Version 1.1.1

* Optional module: sets up a slave with the slave state file
* Optional module: set up a /etc/sudoers.d/jenkins with the sudoersd state file

## Version 1.1.0

* Don't require a deploy SSH private key in the pillar
* Change default webroot where Jenkins unpacks the WAR to be under /var/cache,
  not /var/run. Configurable via the `jenkins:cache_dir` pillar setting
* Fully functional Vagrant dev environment
* Jenkins Plugin salt state/module

## Version 1.0.6

* Enable jenkins user to be added to other groups
* Add metadata.yml for next salt-shaker

## Version 1.0.5

* Logstash is not a formula requirement

## Version 1.0.4

* Bug fix to correct missing formula requirement (logstash dependency).

## Version 1.0.3

* Explicit nginx dependency

## Version 1.0.2

* Documentation

## Version 1.0.1

* Local repo
* Docummented client_max_body_size
* Fix plugins preload

## Version 1.0.0

* Initial checkin
