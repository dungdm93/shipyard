# pylint: disable=missing-docstring
#
# ref: https://linuxize.com/post/create-a-linux-swap-file/
#      https://github.com/openshift/openshift-ansible/blob/master/roles/openshift_node/library/swapoff.py

import subprocess

from ansible.module_utils.basic import AnsibleModule


DOCUMENTATION = '''
---
module: swapoff

short_description: Disable swap and comment from /etc/fstab

version_added: "2.4"

description:
    - This module disables swap and comments entries from /etc/fstab

author:
    - "Michael Gugino <mgugino@redhat.com>"
'''

EXAMPLES = '''
# Pass in a message
- name: Disable Swap
  swapoff: {}
'''


def check_swap_in_fstab(module):
    '''Check for uncommented swap entries in fstab'''
    res = subprocess.call(['grep', '^[^#].*swap', '/etc/fstab'])

    if res == 2:
        # rc 2 == cannot open file.
        result = {'failed': True,
                  'changed': False,
                  'msg': 'unable to read /etc/fstab',
                  'state': 'unknown'}
        module.fail_json(**result)
    elif res == 1:
        # No grep match, fstab looks good.
        check_result = False
    elif res == 0:
        # There is an uncommented entry for fstab.
        check_result = True
    else:
        # Some other grep error code, we shouldn't get here.
        result = {'failed': True,
                  'changed': False,
                  'msg': 'unknown problem with grep "^[^#].*swap" /etc/fstab ',
                  'state': 'unknown'}
        module.fail_json(**result)

    return check_result


def check_swapon_status(module):
    '''Check if swap is actually in use.'''
    try:
        res = subprocess.check_output(['swapon', '--show'])
    except subprocess.CalledProcessError:
        # Some other grep error code, we shouldn't get here.
        result = {'failed': True,
                  'changed': False,
                  'msg': 'unable to execute swapon --show',
                  'state': 'unknown'}
        module.fail_json(**result)
    return 'NAME' in str(res)


def comment_swap_fstab(module):
    '''Comment out swap lines in /etc/fstab'''
    res = subprocess.call(['sed', '-i.bak', 's/^[^#].*swap.*/#&/', '/etc/fstab'])
    if res:
        result = {'failed': True,
                  'changed': False,
                  'msg': 'sed failed to comment swap in /etc/fstab',
                  'state': 'unknown'}
        module.fail_json(**result)


def run_swapoff(module, changed):
    '''Run swapoff command'''
    res = subprocess.call(['swapoff', '--all'])
    if res:
        result = {'failed': True,
                  'changed': changed,
                  'msg': 'swapoff --all returned {}'.format(str(res)),
                  'state': 'unknown'}
        module.fail_json(**result)


def run_module():
    '''Run this module'''
    module = AnsibleModule(
        supports_check_mode=False,
        argument_spec={}
    )
    changed = False

    swap_fstab_res = check_swap_in_fstab(module)
    swap_is_inuse_res = check_swapon_status(module)

    if swap_fstab_res:
        comment_swap_fstab(module)
        changed = True

    if swap_is_inuse_res:
        run_swapoff(module, changed)
        changed = True

    result = {'changed': changed}

    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
