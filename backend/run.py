import os
import sys
from django.core.management import execute_from_command_line

if __name__ == '__main__':
    # Set Django settings
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'maison_backend.settings')

    # Run migrations first automatically
    execute_from_command_line(['manage.py', 'migrate'])

    # Seed database
    execute_from_command_line(['manage.py', 'seed_data'])

    # Run server
    print("Starting Minimalist E-Commerce Django Backend Server on http://localhost:8000 ...")
    execute_from_command_line(['manage.py', 'runserver', '0.0.0.0:8000'])
