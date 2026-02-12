from app import create_app, db
from app.models.user import User
from app.models.community_models import CommunityPost, CommunityComment, PostVote, CommentVote, PostReport, CommentReport
from werkzeug.security import generate_password_hash
from datetime import datetime

app = create_app()

if __name__ == '__main__':
    with app.app_context():
        # Create all database tables
        db.create_all()
        print("✅ Database tables created successfully!")
        
        # Create test user if not exists
        test_user = User.query.filter_by(id="test-user-123").first()
        if not test_user:
            test_user = User(
                id="test-user-123",
                username="testuser",
                email="test@example.com",
                password_hash=generate_password_hash("password123")
            )
            db.session.add(test_user)
            db.session.commit()
            print("✅ Test user created with ID: test-user-123")
    
    app.run(host='0.0.0.0', port=8000, debug=True)