from flask import Flask
from flask_cors import CORS
from dotenv import load_dotenv

load_dotenv()

def create_app():
    app = Flask(__name__)
    CORS(app)

    from .routes import main as main_blueprint
    app.register_blueprint(main_blueprint)

    from .routes.consultant import consultant as consultant_blueprint
    app.register_blueprint(consultant_blueprint)

    return app
