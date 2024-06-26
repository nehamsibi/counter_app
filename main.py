from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal, engine, Base
from models import Counter
from schemas import CounterResponse, CounterUpdate

app = FastAPI()

# Create tables
Base.metadata.create_all(bind=engine)

# Dependency to get the DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/count/", response_model=CounterResponse)
def get_counter(db: Session = Depends(get_db)):
    counter = db.query(Counter).first()
    if not counter:
        counter = Counter(value=0, max_value=10)
        db.add(counter)
        db.commit()
        db.refresh(counter)
    return counter

@app.put("/count/", response_model=CounterResponse)
def update_counter(counter_update: CounterUpdate, db: Session = Depends(get_db)):
    counter = db.query(Counter).first()
    if not counter:
        counter = Counter(value=0, max_value=10)
        db.add(counter)
    counter.value = counter_update.value
    db.commit()
    db.refresh(counter)
    return counter

# from fastapi import FastAPI
# from fastapi.middleware.cors import CORSMiddleware
# from pydantic import BaseModel

# app = FastAPI()

# # Allow CORS for all origins (change as needed for security)
# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],
#     allow_credentials=True,
#     allow_methods=["*"],
#     allow_headers=["*"],
# )

# class Counter(BaseModel):
#     value: int
#     max_value: int

# # Example data (in-memory storage for simplicity)
# counter = Counter(value=0, max_value=10)

# @app.get("/counter")
# def get_counter():
#     return counter

# @app.put("/counter")
# def update_counter(new_counter: Counter):
#     counter.value = new_counter.value
#     return counter

# @app.put("/max_value")
# def update_max_value(new_max_value: int):
#     counter.max_value = new_max_value
#     return counter
# main.py
# from fastapi import FastAPI
# from fastapi.middleware.cors import CORSMiddleware
# from pydantic import BaseModel
# import psycopg2
# import os

# DATABASE_URL = "postgresql://postgres:datapost@localhost/dbsample"


# app = FastAPI()

# # Allow CORS for all origins (change as needed for security)
# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],
#     allow_credentials=True,
#     allow_methods=["*"],
#     allow_headers=["*"],
# )

# class Counter(BaseModel):
#     value: int
#     max_value: int

# # Initialize the database connection
# conn = psycopg2.connect(DATABASE_URL)
# cur = conn.cursor()

# # Create the table if it doesn't exist
# cur.execute('''
#     CREATE TABLE IF NOT EXISTS counter (
#         id SERIAL PRIMARY KEY,
#         value INTEGER NOT NULL,
#         max_value INTEGER NOT NULL
#     )
# ''')
# conn.commit()

# # Insert initial counter value if table is empty
# cur.execute('SELECT COUNT(*) FROM counter')
# if cur.fetchone()[0] == 0:
#     cur.execute('INSERT INTO counter (value, max_value) VALUES (0, 10)')
#     conn.commit()

# @app.get("/counter")
# def get_counter():
#     cur.execute('SELECT value, max_value FROM counter WHERE id = 1')
#     result = cur.fetchone()
#     return {"value": result[0], "max_value": result[1]}

# @app.put("/counter")
# def update_counter(new_counter: Counter):
#     cur.execute('UPDATE counter SET value = %s WHERE id = 1', (new_counter.value,))
#     conn.commit()
#     return new_counter

# @app.put("/max_value")
# def update_max_value(new_max_value: int):
#     cur.execute('UPDATE counter SET max_value = %s WHERE id = 1', (new_max_value,))
#     conn.commit()
#     return {"max_value": new_max_value}
# from fastapi import FastAPI, HTTPException
# from fastapi.middleware.cors import CORSMiddleware
# from pydantic import BaseModel
# import psycopg2
# import os
# import models
# from database import engines,sessionmaker
# from sqlalchemy.orm import session

# # Get the database URL from the environment variable
# DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://user:password@localhost/dbsample")

# # Initialize the FastAPI app
# app = FastAPI()

# # Allow CORS for all origins (change as needed for security)
# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=["*"],
#     allow_credentials=True,
#     allow_methods=["*"],
#     allow_headers=["*"],
# )

# class Counter(BaseModel):
#     value: int
#     max_value: int

# # Initialize the database connection and cursor
# try:
#     conn = psycopg2.connect(DATABASE_URL)
#     cur = conn.cursor()
# except Exception as e:
#     print(f"Error connecting to the database: {e}")
#     conn = None
#     cur = None

# if conn and cur:
#     # Create the table if it doesn't exist
#     cur.execute('''
#         CREATE TABLE IF NOT EXISTS counter (
#             id SERIAL PRIMARY KEY,
#             value INTEGER NOT NULL,
#             max_value INTEGER NOT NULL
#         )
#     ''')
#     conn.commit()

#     # Insert initial counter value if table is empty
#     cur.execute('SELECT COUNT(*) FROM counter')
#     if cur.fetchone()[0] == 0:
#         cur.execute('INSERT INTO counter (value, max_value) VALUES (0, 10)')
#         conn.commit()

# @app.get("/counter", response_model=Counter)
# def get_counter():
#     if not cur:
#         raise HTTPException(status_code=500, detail="Database connection error")
    
#     cur.execute('SELECT value, max_value FROM counter WHERE id = 1')
#     result = cur.fetchone()
#     if result:
#         return Counter(value=result[0], max_value=result[1])
#     else:
#         raise HTTPException(status_code=404, detail="Counter not found")

# @app.put("/counter", response_model=Counter)
# def update_counter(new_counter: Counter):
#     if not cur:
#         raise HTTPException(status_code=500, detail="Database connection error")
    
#     cur.execute('UPDATE counter SET value = %s WHERE id = 1 RETURNING value, max_value', (new_counter.value,))
#     conn.commit()
#     updated = cur.fetchone()
#     if updated:
#         return Counter(value=updated[0], max_value=updated[1])
#     else:
#         raise HTTPException(status_code=404, detail="Failed to update counter")

# @app.put("/max_value", response_model=Counter)
# def update_max_value(new_max_value: int):
#     if not cur:
#         raise HTTPException(status_code=500, detail="Database connection error")
    
#     cur.execute('UPDATE counter SET max_value = %s WHERE id = 1 RETURNING value, max_value', (new_max_value,))
#     conn.commit()
#     updated = cur.fetchone()
#     if updated:
#         return Counter(value=updated[0], max_value=updated[1])
#     else:
#         raise HTTPException(status_code=404, detail="Failed to update max value")

# if __name__ == "__main__":
#     import uvicorn
#     uvicorn.run(app, host="0.0.0.0", port=8000)
