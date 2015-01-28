import os
import requests
import logging
import json

import salt.exceptions
import salt.utils

log = logging.getLogger(__name__)

def install_plugin(name,
            version=None,
            jenkins_url="http://localhost:8877"):
    """
    Installs specified Jenkins plugin
    You can specify a required version - otherwise it will install the latest version.
    """
    url = jenkins_url+'/pluginManager/installNecessaryPlugins'
    if version is None:
        payload = '<jenkins><install plugin="{0}" /></jenkins>'.format(name)
    else:
        payload = '<jenkins><install plugin="{0}@{1}" /></jenkins>'.format(name,version)
    log.debug("Posting {0} to {1}".format(payload, url))

    headers = {'Content-Type': 'application/xml'}
    r = requests.post(url, data=payload, headers=headers)
    if r.status_code not in [200, 201]:
        log.error('Jenkins no like: {0} Reason: {1}'.format(x.status_code, x.text))
        return False
    log.info("Jenkins installing {0}".format(name))
    return True

def _list_plugin(jenkins_url):
    url = jenkins_url+'/pluginManager/api/json?tree=plugins[shortName,version]'
    headers = {'Content-Type': 'application/xml'}
    r = requests.get(url,headers=headers)
    installed_plugins = r.json()['plugins']
    log.debug(installed_plugins)
    return installed_plugins

def current_state(name,
		  version=None,
		  jenkins_url="http://localhost:8877"):

    installed_plugins = _list_plugin(jenkins_url)
    for plugin in installed_plugins:
	if version is None:
	    if name == plugin["shortName"]:
		return True
	elif name == plugin["shortName"] and version == plugin["version"]:
	    return True
    return False

