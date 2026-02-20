from flask import Blueprint, request, jsonify
import requests
import psycopg2
import os

consultancy_bp = Blueprint("consultancy", __name__)

GOOGLE_API_KEY = os.getenv("GOOGLE_PLACES_KEY")
DB_URL = os.getenv("DATABASE_URL")


def get_db():
    return psycopg2.connect(DB_URL)


# ================= NEARBY PSYCHOLOGISTS =================
# FINAL PATH: /api/psychologists/nearby
@consultancy_bp.route("/nearby", methods=["GET"])
def nearby_psychologists():
    lat = request.args.get("lat")
    lng = request.args.get("lng")

    if not lat or not lng:
        return jsonify({"error": "lat and lng required"}), 400

    try:
        lat = float(lat)
        lng = float(lng)
    except ValueError:
        return jsonify({"error": "invalid coordinates"}), 400

    if not GOOGLE_API_KEY:
        return jsonify({"error": "Google API key missing"}), 500

    url = (
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        f"?location={lat},{lng}"
        "&radius=5000"
        "&keyword=psychologist"
        f"&key={GOOGLE_API_KEY}"
    )

    res = requests.get(url).json()

    results = []
    for p in res.get("results", []):
        results.append({
            "name": p.get("name"),
            "address": p.get("vicinity"),
            "lat": p["geometry"]["location"]["lat"],
            "lng": p["geometry"]["location"]["lng"],
            "place_id": p.get("place_id"),
            "rating": p.get("rating")
        })

    return jsonify(results)


# ================= CREATE REQUEST =================
# FINAL PATH: /api/psychologists/consultation-request
@consultancy_bp.route("/consultation-request", methods=["POST"])
def create_request():
    data = request.json

    required = ["user_id", "psychologist_name", "clinic_address", "city"]
    for f in required:
        if f not in data:
            return jsonify({"error": f"{f} required"}), 400

    conn = get_db()
    cur = conn.cursor()

    cur.execute("""
        INSERT INTO consultation_requests
        (user_id, psychologist_name, specialization, clinic_address,
         city, latitude, longitude, place_id, message, preferred_date)
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
    """, (
        data["user_id"],
        data.get("psychologist_name"),
        data.get("specialization"),
        data.get("clinic_address"),
        data.get("city"),
        data.get("latitude"),
        data.get("longitude"),
        data.get("place_id"),
        data.get("message"),
        data.get("preferred_date"),
    ))

    conn.commit()
    cur.close()
    conn.close()

    return jsonify({"status": "request_created"})


# ================= USER REQUESTS =================
# FINAL PATH: /api/psychologists/my-consultations/<user_id>
@consultancy_bp.route("/my-consultations/<user_id>", methods=["GET"])
def my_consultations(user_id):
    conn = get_db()
    cur = conn.cursor()

    cur.execute("""
        SELECT psychologist_name, clinic_address, city,
               preferred_date, status, created_at
        FROM consultation_requests
        WHERE user_id = %s
        ORDER BY created_at DESC
    """, (user_id,))

    rows = cur.fetchall()

    result = []
    for r in rows:
        result.append({
            "psychologist_name": r[0],
            "clinic_address": r[1],
            "city": r[2],
            "preferred_date": str(r[3]) if r[3] else None,
            "status": r[4],
            "created_at": str(r[5])
        })

    cur.close()
    conn.close()

    return jsonify(result)