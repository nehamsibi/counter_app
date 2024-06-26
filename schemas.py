from pydantic import BaseModel

class CounterResponse(BaseModel):
    id: int
    value: int
    max_value: int

    class Config:
        orm_mode = True

class CounterUpdate(BaseModel):
    max_value: int
