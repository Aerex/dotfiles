#! /usr/bin/env python2
from subprocess import check_output

def get_pass(account):
    output = check_output('pass Email/' + account, shell=True).splitlines()[0]
    print('output {}'.format(output))
    return output

def get_user(account):
    output = check_output('pass Email/' + account, shell=True).splitlines()
    user = output[1].replace('login:', '').replace(' ', '')
    return user

def get_imap_host(account):
    output = check_output('pass Email/' + account, shell=True).splitlines()
    imap_host = output[3].replace('imap_domain:', '').replace(' ', '')
    return imap_host

def get_imap_port(account):
    output = check_output('pass Email/' + account, shell=True).splitlines()
    imap_port = output[5].replace('imap_port:', '').replace(' ', '')
    return imap_port

