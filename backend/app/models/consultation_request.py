from app import db
from datetime import datetime

class ConsultationRequest(db.Model):
    __tablename__ = "consultation_requests"

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.String(36))

    psychologist_name = db.Column(db.String(150))
    specialization = db.Column(db.String(150))
    clinic_address = db.Column(db.Text)
    city = db.Column(db.String(100))
    latitude = db.Column(db.Float)
    longitude = db.Column(db.Float)
    place_id = db.Column(db.String(150))

    message = db.Column(db.Text)
    preferred_date = db.Column(db.String(20))

    status = db.Column(db.String(20), default="pending")
    created_at = db.Column(db.DateTime, default=datetime.utcnow)