import os
import urllib2
import logging
import json
import time

import salt.exceptions
import salt.utils

log = logging.getLogger(__name__)

def plugin_installed(name,
            version=None,
            jenkins_url="http://localhost:8877"):
    '''
    Enforces that a jenkins plugin is installed and optionally at
    the correct version.

    name
        The shortname of the jenkins plugin
    version
        The version of the plugin that should be installed
    jenkins_url
        The url of jenkins http://localhost:8877 by default
    '''

    ret = {
        'name': name,
        'changes': {},
        'result': False,
        'comment': ''
    }

    current_state = __salt__['jenkins.plugin_installed'](name,version,jenkins_url)
    if current_state['result']:
        ret['result']  = True
        ret['comment'] = 'Plugin already installed'
        return ret
    else:
        if current_state['version'] is not None:
            ret['comment'] = 'Plugin installed but wrong version currently {0}'.format(current_state['version'])
        else:
            new_state = __salt__['jenkins.install_plugin'](name,version,jenkins_url)
            if new_state['result']:
                log.debug("Jenkins plugin installed successfully")
                ret['result'] = True
                ret['comment'] = "Successfully installed {0}: v{1}".format(name,version)
                ret['changes'] = {
                    'old': current_state['version'],
                    'new': new_state['version'] 
                }
        return ret
