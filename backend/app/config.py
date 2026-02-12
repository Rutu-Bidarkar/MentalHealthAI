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