from flask import Blueprint, jsonify, request

main = Blueprint("main", __name__)

@main.route("/")
def index():
    return jsonify({
        "status": "Antigravity Mental Health AI Backend is running",
        "endpoints": {
            "/health": "GET",
            "/api/screening/session": "POST",
            "/api/screening/report": "POST"
        }
    })

@main.route("/health")
def health():
    return jsonify({"status": "ok"})
@main.route("/api/screening/session", methods=["POST"])
def save_session():
    data = request.get_json(silent=True)
    if not data:
        return jsonify({"error": "Invalid JSON"}), 400
    
    # For now, we'll just log the session data since there's no DB persistence yet
    print(f"Received screening session: {data.get('module_name')} - {data.get('result_band')}")
    
    return jsonify({"status": "success", "message": "Session saved locally"}), 201
