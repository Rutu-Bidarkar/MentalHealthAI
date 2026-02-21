import os
from datetime import timedelta

class Config:
    SECRET_KEY = 'dev-secret-key-change-in-production'
    
    # ABSOLUTE PATH - FIXED
    basedir = os.path.abspath(os.path.dirname(os.path.dirname(__file__)))
    instance_path = os.path.join(basedir, 'instance')
    db_path = os.path.join(instance_path, 'mentalhealth.db')
    
    # Ensure instance folder exists
    os.makedirs(instance_path, exist_ok=True)
    
    SQLALCHEMY_DATABASE_URI = f'sqlite:///{db_path}'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # JWT Settings
    JWT_SECRET_KEY = 'jwt-secret-key-change-in-production'
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(hours=1)
    JWT_REFRESH_TOKEN_EXPIRES = timedelta(days=30)
    
    # CORS
    CORS_ORIGINS = ['*']
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'flask-secret-key-change-in-production-789012'
    
    # Database - SQLite for local development
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'sqlite:///' + os.path.join(os.path.dirname(os.path.dirname(__file__)), 'db', 'mental_health.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # JWT
    JWT_SECRET_KEY = os.environ.get('JWT_SECRET_KEY') or 'your-super-secret-key-change-in-production-123456'
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(hours=1)  # Changed from minutes to hours
    JWT_TOKEN_LOCATION = ['headers']
    
    # CORS
    CORS_ORIGINS = os.environ.get('CORS_ORIGINS', '*').split(',')
