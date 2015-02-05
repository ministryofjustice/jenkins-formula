import os
import requests
import logging
import json
import datetime
import time

import salt.exceptions
import salt.utils

log = logging.getLogger(__name__)

def install_plugin(name,
            version=None,
            jenkins_url="http://localhost:8877",
            timeout=60):
    """
    Installs specified Jenkins plugin
    You can specify a required version - otherwise it will install the latest version.
    CLI Example::

        salt '*' jenkins.install_plugin git 2.3.4
    """
    url = jenkins_url+'/pluginManager/installNecessaryPlugins'
    if version is None:
        payload = '<jenkins><install plugin="{0}@latest" /></jenkins>'.format(name)
    else:
        payload = '<jenkins><install plugin="{0}@{1}" /></jenkins>'.format(name,version)
    log.debug("Posting {0} to {1}".format(payload, url))

    headers = {'Content-Type': 'text/xml'}
    r = requests.post(url, data=payload, headers=headers)
    if r.status_code not in [200, 201]:
        log.error("Jenkins no like: {0} Reason: {1}".format(r.status_code, r.text.encode('utf-8')))
        return {'result':False}
    log.info("Jenkins installing {0}".format(name))
    start_time = datetime.datetime.now()
    while True:
        result = plugin_installed(name,version,jenkins_url)
        if result['result']:
            log.info("Jenkins installed {0} successfully".format(name))
            return result
        if datetime.datetime.now() > (start_time + datetime.timedelta(seconds=timeout)):
            break
        time.sleep(5)
    log.info("Time out waiting for jenkins to install plugin {0}".format(name))
    return result

def _list_plugin(jenkins_url):
    """
    Internal function, gets list of all installed plugins
    """
    url = jenkins_url+'/pluginManager/api/json?tree=plugins[shortName,version]'
    headers = {'Content-Type': 'application/xml'}
    r = requests.get(url,headers=headers)
    installed_plugins = r.json()['plugins']
    log.debug(installed_plugins)
    return installed_plugins

def plugin_installed(name,
		  version=None,
		  jenkins_url="http://localhost:8877"):
    """
    Checks if plugin is installed. Returns True or False.
    You can specify a required version - otherwise it will check for any version
    CLI Example::

        salt '*' jenkins.plugin_installed git 2.3.4
    """

    ret = {'result': False,
           'name': name,
           'version': None}
    installed_plugins = _list_plugin(jenkins_url)
    for plugin in installed_plugins:
	if version is None:
	    if name == plugin["shortName"]:
                ret['version'] = plugin['version']
                ret['result'] = True
		return ret
	elif name == plugin["shortName"] and version == plugin["version"]:
            ret['version'] = plugin['version']
            ret['result'] = True
	    return ret
        elif name == plugin["shortName"]:
            log.info("Plugin installed but not specified version")
            ret['version'] = plugin['version']
            ret['result'] = False
            return ret
    return ret

