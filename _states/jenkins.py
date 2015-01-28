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

    ret = {
        'name': name,
        'changes': {},
        'result': False,
        'comment': ''
    }

    current_state = __salt__['jenkins.current_state'](name,version,jenkins_url)
    if current_state:
        ret['result']  = True
        ret['comment'] = 'System already in the correct state'
        return ret
    else:
        new_state = __salt__['jenkins.install_plugin'](name,version,jenkins_url)
        if new_state:
            log.debug("Jenkins install started, did it succeed?...")
            for attempt in range(0,4):
                time.sleep(10)
                new_state = __salt__['jenkins.current_state'](name,version,jenkins_url)
                if new_state:
                    ret['result']  = True
                    ret['comment'] = 'Triggered Jenkins plugins install'
                    return ret
            ret['result'] = False
            ret['comment'] = 'Timed out waiting for jenkins to install the plugin'
            return ret


    return ret
