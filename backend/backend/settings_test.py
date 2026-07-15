'''Settings for deterministic pytest/pytest-django experiment runs.'''

import os

from django.core.exceptions import ImproperlyConfigured

from .settings import *  # noqa: F403


TEST_DB_NAME = os.getenv('TEST_DB_NAME', 'ecommerce_course_project_test')
DEVELOPMENT_DB_NAME = os.getenv('DB_NAME')

if DEVELOPMENT_DB_NAME and TEST_DB_NAME == DEVELOPMENT_DB_NAME:
    raise ImproperlyConfigured(
        'TEST_DB_NAME must not be the same database as DB_NAME.'
    )

DATABASES['default']['TEST'] = {'NAME': TEST_DB_NAME}  # noqa: F405
DEBUG = False
PASSWORD_HASHERS = ['django.contrib.auth.hashers.MD5PasswordHasher']
