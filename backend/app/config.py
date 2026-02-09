import os
from datetime import timedelta

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'flask-secret-key-change-in-production-789012'
    
    # Database - FIXED PASSWORD
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'postgresql://admin:secret123@localhost:5432/mental_health_app'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # JWT
    JWT_SECRET_KEY = os.environ.get('JWT_SECRET_KEY') or 'your-super-secret-key-change-in-production-123456'
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(hours=1)  # Changed from minutes to hours
    JWT_TOKEN_LOCATION = ['headers']
    
    # CORS
    CORS_ORIGINS = os.environ.get('CORS_ORIGINS', '*').split(',')
