from app import db

class Psychologist(db.Model):
    __tablename__ = "psychologists"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), nullable=False)
    specialization = db.Column(db.String(120))
    address = db.Column(db.String(200))
    
    city = db.Column(db.String(80))
    
    latitude = db.Column(db.Float)
    longitude = db.Column(db.Float)
    
    rating = db.Column(db.Float)
    fee = db.Column(db.Integer)