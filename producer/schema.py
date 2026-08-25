from pydantic import BaseModel
from datetime import datetime


class Location(BaseModel):
    country: str
    city: str 


class Transaction(BaseModel):
    txn_id: str
    account_id: str
    merchant_id: str
    amount: float
    currency: str
    txn_type: str
    channel: str 
    status: str
    merchant_category:str
    location: Location
    device_id: str
    ip_address: str
    event_timestamp: datetime
    ingestion_timestamp: datetime
    
