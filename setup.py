#!/usr/bin/python

try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup


config = {
    'name': 'salt-terraform-demo',
    'packages': ['simplerpc'],
    'url': 'https://github.com/dguitarbite/salt-terraform-demo',
}

setup(**config)
