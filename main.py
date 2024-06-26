from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal, engine, Base
from models import Counter
from schemas import CounterResponse, CounterUpdate

app = FastAPI()
Base.metadata.create_all(bind=engine)

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

