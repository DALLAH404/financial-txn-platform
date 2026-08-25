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
    
# txn = Transaction(
#     txn_id="abc-123",
#     account_id="acc-1",
#     merchant_id="merch-1",
#     amount=56.5,
#     currency="USD",
#     txn_type="purchase",
#     channel="pos",
#     status="completed",
#     merchant_category="grocery",
#     location={"country": "EG", "city": "Cairo"},   
#     device_id="dev-1",
#     ip_address="1.2.3.4",
#     event_timestamp=datetime.now(),
#     ingestion_timestamp=datetime.now(),
# )

# print(txn.event_timestamp)
