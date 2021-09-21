#! /usr/bin/env python2
from subprocess import check_output
import re

def get_pass(account):
    output = check_output('pass Email/' + account, shell=True).splitlines()[0]
    return output

def get_user(account):
    output = check_output('pass Email/' + account, shell=True).splitlines()
    user = output[1].replace('login:', '').replace(' ', '')
    return user

def get_imap_host(account):
    lines = check_output('pass Email/' + account, shell=True).splitlines()
    for line in lines:
        if re.search("imap_domain", line):
            imap_host = line.replace('imap_domain:', '').replace(' ', '')
            return imap_host

def get_imap_port(account):
    lines = check_output('pass Email/' + account, shell=True).splitlines()
    for line in lines:
        if re.search('imap_port', line):
            imap_port = line.replace('imap_port:', '').replace(' ', '')
            return imap_port

