from app import create_app, db
from app.models.user import User
from app.models.community_models import (
    CommunityPost, CommunityComment, PostVote,
    CommentVote, PostReport, CommentReport
)
from werkzeug.security import generate_password_hash

app = create_app()

if __name__ == "__main__":
    with app.app_context():
        # Create all database tables
        db.create_all()
        print("✅ Database tables created successfully!")

        # Create test user ONLY if not exists (check by email or id)
        existing_user = User.query.filter(
            (User.id == "test-user-123") |
            (User.email == "test@example.com")
        ).first()

        if not existing_user:
            test_user = User(
                id="test-user-123",
                username="testuser",
                email="test@example.com",
                password_hash=generate_password_hash("password123"),
                account_type="individual",
                age_group="over_18"
            )
            db.session.add(test_user)
            db.session.commit()
            print("✅ Test user created with ID: test-user-123")
        else:
            print("ℹ️ Test user already exists")

    app.run(host="0.0.0.0", port=8000, debug=True)