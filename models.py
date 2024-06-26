from sqlalchemy import Column, Integer
from database import Base

class Counter(Base):
    __tablename__ = "counters"
    id = Column(Integer, primary_key=True, index=True)
    value = Column(Integer, default=0)
    max_value = Column(Integer, default=10)
