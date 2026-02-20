from flask import Blueprint, request, jsonify
import requests
import os
from app import db
from sqlalchemy import text

psychologist_bp = Blueprint("psychologist", __name__)

GOOGLE_API_KEY = os.getenv("GOOGLE_PLACES_KEY")


# ---------- GEOCODE FUNCTION ----------
def geocode_location(location):
    url = "https://maps.googleapis.com/maps/api/geocode/json"
    params = {
        "address": f"{location}, India",
        "key": GOOGLE_API_KEY
    }

    res = requests.get(url, params=params).json()

    if res.get("status") != "OK":
        print("GEOCODE ERROR:", res)
        return None

    loc = res["results"][0]["geometry"]["location"]
    return loc["lat"], loc["lng"]


# ---------- NEARBY ----------
@psychologist_bp.route("/nearby", methods=["GET"])
def nearby_psychologists():
    location = request.args.get("location")

    if not location:
        return jsonify({"error": "location required"}), 400

    coords = geocode_location(location)

    if not coords:
        return jsonify({"error": "Location not found"}), 400

    lat, lng = coords

    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    params = {
        "location": f"{lat},{lng}",
        "radius": 5000,
        "keyword": "psychologist",
        "key": GOOGLE_API_KEY
    }

    res = requests.get(url, params=params).json()

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