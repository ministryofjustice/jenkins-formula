import os
import urllib2
import logging
import json
import time

import salt.exceptions
import salt.utils

log = logging.getLogger(__name__)

def ensure_system_user_apikey_grain(name,
            grain_name='jenkins_system_user_token',
            jenkins_url = "http://127.0.0.1:8877/user/system/configure"):
    '''
    Get the jenkins SYSTEM user's API token and keep it in a grain to
    be able to use it to call the api after enabling auth.

    name
        Name of the salt state
    grain_name
        Name for the newly created grain
    jenkins_url
        Jenkins URL where the token is found
    '''
    import requests
    from BeautifulSoup import BeautifulSoup

    ret = {
        'name': name,
        'changes': {},
        'result': False,
        'comment': ''
    }

    if __salt__['grains.get'](grain_name):
        # Already exists, return its
        ret['result'] = True
        return ret

    try:
        response = requests.get(jenkins_url).text
        soup = BeautifulSoup(response)
        api_key = soup.find(id="apiToken")['value']
    except TypeError:
        ret['result'] = False
        ret['comment'] = "Couldn't find the key apiToken in {}".format(jenkins_url)
        return ret
    except Exception as e:
        ret['result'] = False
        ret['comment'] = e.message
        return ret

    __salt__['grains.setval'](grain_name, api_key)
    ret['changes'] = { 'old': None, 'new': api_key }
    ret['comment'] = "API token fetched and stored to grain {0}".format(grain_name)
    ret['result'] = True

    return ret


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
