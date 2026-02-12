from flask import Flask
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from .config import Config

db = SQLAlchemy()
jwt = JWTManager()

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)
    
    # Initialize extensions
    db.init_app(app)
    jwt.init_app(app)
    CORS(app, resources={r"/api/*": {"origins": "*"}})
    
    # Register blueprints
    from app.routes.auth import auth_bp
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    
    from app.routes.assessment import assessment_bp
    app.register_blueprint(assessment_bp, url_prefix='/api/assessment')
    
    from app.routes.community_routes import community_bp
    app.register_blueprint(community_bp, url_prefix='/api/community')

    # ✅ ADD THESE TWO
    from app.routes.popslash import popslash_bp
    app.register_blueprint(popslash_bp, url_prefix='/api/popslash')

    from app.routes.memorylane import memorylane_bp
    app.register_blueprint(memorylane_bp, url_prefix='/api/memorylane')

    @app.route('/')
    def index():
        return {'message': 'Mental Health Flask API', 'status': 'running'}
    
    @app.route('/health')
    def health():
        return {'status': 'healthy'}
    
    return app
