#!/usr/bin/python2
# Simple api for simplerpc


import sys


def getargs():
    """Get args and return them."""

    args = sys.argv
    if len(args) == 3:
        HOSTURI = sys.argv[1]
        EXCHANGE = sys.argv[2]
    elif len(args) == 2:
        HOSTURI = sys.argv[1]
        EXCHANGE = ''
    else:
        HOSTURI = 'localhost'
        EXCHANGE = ''

    return HOSTURI, EXCHANGE
