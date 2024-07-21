#! /usr/bin/env python3
from subprocess import check_output
import re

def get_pass(account):
    output = check_output('pass Email/' + account, shell=True, encoding='utf-8').splitlines()[0]
    return output

def get_user(account):
    lines = check_output('pass Email/' + account, shell=True, encoding='utf-8').splitlines()
    for line in lines:
        if re.search('login:', line):
            return line.replace('login:', '').replace(' ', '')

def get_imap_host(account):
    lines = check_output('pass Email/' + account, shell=True, encoding='utf-8').splitlines()
    for line in lines:
        if re.search('imap_domain:', line):
            return line.replace('imap_domain:', '').replace(' ', '')

def get_imap_port(account):
    lines = check_output('pass Email/' + account, shell=True, encoding='utf-8').splitlines()
    for line in lines:
        if re.search('imap_port:', line):
            return line.replace('imap_port:', '').replace(' ', '')
