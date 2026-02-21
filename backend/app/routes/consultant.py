import csv, os
from flask import Blueprint, render_template, jsonify

consultant = Blueprint("consultant", __name__, url_prefix="/consultant")

DATA_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), "data")


def load_csv():
    path = os.path.join(DATA_DIR, "mental_health_dummy_data.csv")
    rows = []
    with open(path, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            rows.append(row)
    return rows


def compute_dashboard_stats(rows):
    unique_users = set(r["user_id"] for r in rows)
    total_journals = sum(int(r["journal_entry_count"]) for r in rows)
    mood_vals = [float(r["emotion_score"]) for r in rows if r["emotion_score"]]
    avg_mood = round(sum(mood_vals) / len(mood_vals), 1) if mood_vals else 0
    total_tests = sum(int(r["tests_completed"]) for r in rows)

    emotion_counts = {}
    for r in rows:
        e = r["primary_emotion"]
        emotion_counts[e] = emotion_counts.get(e, 0) + 1
    total_e = sum(emotion_counts.values())
    mood_dist = {k: round(v / total_e * 100) for k, v in emotion_counts.items()}

    activity_dist = {
        "Journaling": 45, "Tests": 25, "Games": 15, "Voice": 10, "Reports": 5
    }

    # Trend — group by date, average emotion_score
    date_scores = {}
    for r in rows:
        d = r["date"]
        if d not in date_scores:
            date_scores[d] = []
        try:
            date_scores[d].append(float(r["emotion_score"]))
        except ValueError:
            pass
    trend = [
        {"date": d, "score": round(sum(v) / len(v), 1)}
        for d, v in sorted(date_scores.items())
    ][-30:]

    return {
        "total_users": len(unique_users),
        "total_journals": total_journals,
        "avg_mood": avg_mood,
        "total_tests": total_tests,
        "mood_dist": mood_dist,
        "activity_dist": activity_dist,
        "trend": trend,
    }


def build_patient_list(rows):
    patients = {}
    for r in rows:
        uid = r["user_id"]
        if uid not in patients:
            patients[uid] = {
                "id": uid,
                "sessions": 0,
                "journal_entries": 0,
                "emotions": [],
                "anxiety_scores": [],
                "depression_scores": [],
                "stress_scores": [],
                "mood_scores": [],
                "dates": [],
                "last_date": "",
            }
        p = patients[uid]
        p["sessions"] += 1
        p["journal_entries"] += int(r["journal_entry_count"])
        p["emotions"].append(r["primary_emotion"])
        try:
            p["anxiety_scores"].append(float(r["anxiety_score"]))
            p["depression_scores"].append(float(r["depression_score"]))
            p["stress_scores"].append(float(r["stress_level"].replace("High", "8").replace("Medium", "5").replace("Low", "2")))
            p["mood_scores"].append(float(r["emotion_score"]))
        except Exception:
            pass
        if r["date"] > p["last_date"]:
            p["last_date"] = r["date"]

    patient_list = []
    NAMES = {
        "USER001": ("Kavya Iyer", "25", "F", "Software Engineer", "Bangalore"),
        "USER002": ("Rahul Mehta", "32", "M", "Marketing Manager", "Mumbai"),
        "USER003": ("Ananya Deshmukh", "28", "F", "Teacher", "Pune"),
        "USER004": ("Arjun Singh", "35", "M", "Business Owner", "Delhi"),
        "USER005": ("Meera Patel", "29", "F", "Doctor", "Ahmedabad"),
        "USER006": ("Rohan Sharma", "31", "M", "Engineer", "Hyderabad"),
        "USER007": ("Priya Nair", "26", "F", "Designer", "Chennai"),
        "USER008": ("Vikram Joshi", "40", "M", "Manager", "Kolkata"),
        "USER009": ("Sneha Iyer", "33", "F", "Analyst", "Jaipur"),
        "USER010": ("Aditya Kumar", "27", "M", "Developer", "Bangalore"),
        "USER011": ("Divya Menon", "38", "F", "HR Executive", "Mumbai"),
        "USER012": ("Sanjay Gupta", "45", "M", "Accountant", "Delhi"),
        "USER013": ("Pooja Verma", "22", "F", "Student", "Pune"),
        "USER014": ("Nikhil Reddy", "36", "M", "Consultant", "Hyderabad"),
        "USER015": ("Lakshmi Rao", "30", "F", "Nurse", "Chennai"),
        "USER016": ("Karan Malhotra", "29", "M", "Sales Executive", "Jaipur"),
        "USER017": ("Ayesha Khan", "24", "F", "Journalist", "Mumbai"),
        "USER018": ("Suresh Pillai", "42", "M", "Teacher", "Kolkata"),
        "USER019": ("Nandita Roy", "37", "F", "Architect", "Ahmedabad"),
        "USER020": ("Rajesh Tiwari", "50", "M", "Retired", "Delhi"),
    }

    for uid, p in patients.items():
        name_info = NAMES.get(uid, (uid, "30", "M", "Professional", "India"))
        avg_dep = round(sum(p["depression_scores"]) / len(p["depression_scores"]), 1) if p["depression_scores"] else 0
        avg_anx = round(sum(p["anxiety_scores"]) / len(p["anxiety_scores"]), 1) if p["anxiety_scores"] else 0
        avg_mood = round(sum(p["mood_scores"]) / len(p["mood_scores"]), 1) if p["mood_scores"] else 0
        risk = "high" if avg_dep > 15 or avg_anx > 14 else ("medium" if avg_dep > 10 or avg_anx > 9 else "low")
        patient_list.append({
            "id": uid,
            "name": name_info[0],
            "age": name_info[1],
            "gender": name_info[2],
            "profession": name_info[3],
            "location": name_info[4],
            "sessions": p["sessions"],
            "journal_entries": p["journal_entries"],
            "avg_depression": avg_dep,
            "avg_anxiety": avg_anx,
            "avg_mood": avg_mood,
            "risk": risk,
            "last_date": p["last_date"],
        })

    patient_list.sort(key=lambda x: x["last_date"], reverse=True)
    return patient_list


# ── Routes ─────────────────────────────────────────────────────────────────────

@consultant.route("/")
def register():
    return render_template("consultant/register.html")


@consultant.route("/dashboard")
def dashboard():
    rows = load_csv()
    stats = compute_dashboard_stats(rows)
    patients = build_patient_list(rows)[:5]
    return render_template("consultant/dashboard.html", stats=stats, patients=patients)


@consultant.route("/patients")
def patients():
    rows = load_csv()
    patient_list = build_patient_list(rows)
    return render_template("consultant/patients.html", patients=patient_list)


@consultant.route("/patient/<uid>")
def patient_detail(uid):
    rows = load_csv()
    patient_rows = [r for r in rows if r["user_id"] == uid]
    all_patients = build_patient_list(rows)
    patient = next((p for p in all_patients if p["id"] == uid), None)
    if not patient:
        return "Patient not found", 404

    trend = [
        {"date": r["date"], "score": float(r["emotion_score"])}
        for r in sorted(patient_rows, key=lambda x: x["date"])
    ]
    latest = patient_rows[-1] if patient_rows else {}
    return render_template(
        "consultant/patient_detail.html",
        patient=patient,
        trend=trend,
        latest=latest,
        total_rows=len(patient_rows),
    )


@consultant.route("/schedule")
def schedule():
    patients = build_patient_list(load_csv())[:6]
    return render_template("consultant/schedule.html", patients=patients)


@consultant.route("/billing")
def billing():
    patients = build_patient_list(load_csv())
    return render_template("consultant/billing.html", patients=patients[:10])


@consultant.route("/profile")
def profile():
    return render_template("consultant/profile.html")


# ── API endpoints for chart data ────────────────────────────────────────────────

@consultant.route("/api/trend/<uid>")
def api_trend(uid):
    rows = load_csv()
    patient_rows = [r for r in rows if r["user_id"] == uid]
    trend = [
        {"date": r["date"], "score": float(r["emotion_score"])}
        for r in sorted(patient_rows, key=lambda x: x["date"])
    ]
    return jsonify(trend)


@consultant.route("/api/stats")
def api_stats():
    rows = load_csv()
    return jsonify(compute_dashboard_stats(rows))
