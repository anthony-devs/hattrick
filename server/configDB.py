from app import app, db  # Import your Flask app and db instance

# Create an application context
with app.app_context():
    #db.session.flush()
    #db.drop_all()
    db.create_all()