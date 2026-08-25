import random
import uuid
from datetime import datetime, timedelta
from faker import Faker
from schema import Transaction, Location


fake = Faker()

ACCOUNT_IDS = [f"acc-{i}" for i in range(1,51)] 

MERCHANT_POOL = [
    {"merchant_id": f"merch-{i}", "category": random.choice(
        ["grocery", "travel", "electronics", "restaurant", "utilities"])}
    for i in range(1,21)
]

TXN_TYPES =  ["purchase", "refund", "withdrawal", "transfer"]
CHANNELS = ["pos", "online", "atm", "mobile"]
STATUSES = ["completed", "pending", "failed"]

def _fake_amount(txn_type: str) -> float:
    # mostly small purchases, occasional large ones
    if txn_type == "withdrawal":
        return round(random.uniform(20,100),2)
    return round(random.choices(
        [random.uniform(5,100), random.uniform(100,2000)],
        weights=[0.9,0.1]
    )[0],2)


def _fake_event_timestamp() -> datetime:
    # occasionally simulate late-arriving events
    jitter_minutes = random.choices([0, random.randint(1, 180)], weights=[0.85, 0.15])[0]
    return datetime.now() - timedelta(minutes=jitter_minutes)


def generate_transaction() -> Transaction:
    merchant = random.choice(MERCHANT_POOL)
    txn_type = random.choice(TXN_TYPES)

    return Transaction(
        txn_id=str(uuid.uuid4()),
        account_id=random.choice(ACCOUNT_IDS),
        merchant_id=merchant["merchant_id"],
        amount=_fake_amount(txn_type),
        currency=random.choice(["USD", "EUR", "GBP", "EGP"]),
        txn_type=txn_type,
        channel=random.choice(CHANNELS),
        status=random.choice(STATUSES),
        merchant_category=merchant["category"],
        location=Location(country=fake.country_code(), city=fake.city()),
        device_id=f"dev-{random.randint(1, 200)}",
        ip_address=fake.ipv4(),
        event_timestamp=_fake_event_timestamp(),
        ingestion_timestamp=datetime.now(),
    )
