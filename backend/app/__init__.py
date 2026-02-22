from flask import Flask
from flask_cors import CORS
from dotenv import load_dotenv

load_dotenv()

def create_app():
    app = Flask(__name__)
    CORS(app)

    from .routes import main as main_blueprint
    app.register_blueprint(main_blueprint)

    from .ai.report_generator import report_bp
    app.register_blueprint(report_bp)

    return app

