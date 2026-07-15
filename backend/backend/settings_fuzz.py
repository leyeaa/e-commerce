'''Settings for the standalone server targeted by Schemathesis.

This module refuses to start if the fuzz database name matches the development
database name.
'''

import os

from django.core.exceptions import ImproperlyConfigured

from .settings import *  # noqa: F403


FUZZ_DB_NAME = os.getenv('FUZZ_DB_NAME', 'ecommerce_course_project_fuzz')
DEVELOPMENT_DB_NAME = os.getenv('DB_NAME')

if not FUZZ_DB_NAME:
    raise ImproperlyConfigured('FUZZ_DB_NAME must be configured.')

if DEVELOPMENT_DB_NAME and FUZZ_DB_NAME == DEVELOPMENT_DB_NAME:
    raise ImproperlyConfigured(
        'FUZZ_DB_NAME must not be the same database as DB_NAME.'
    )

DATABASES['default']['NAME'] = FUZZ_DB_NAME  # noqa: F405
DEBUG = False
ALLOWED_HOSTS = ['127.0.0.1', 'localhost']
