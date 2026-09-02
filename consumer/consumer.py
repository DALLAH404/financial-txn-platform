# producer/consumer.py  (or a new consumer/ folder — your call)
import json
import uuid
from datetime import datetime, timezone
from confluent_kafka import Consumer
import boto3

BATCH_SIZE = 20
S3_BUCKET = "financial-txn-dev-raw-0eff"

conf = {
    "bootstrap.servers": "172.31.31.61:9095", 
    "group.id": "raw-zone-consumer",
    "auto.offset.reset": "earliest",
}

consumer = Consumer(conf)
consumer.subscribe(["transactions"])
s3 = boto3.client("s3")

batch = []

def flush_batch(batch):
    if not batch:
        return
    now = datetime.now(timezone.utc)
    key = f"raw/year={now:%Y}/month={now:%m}/day={now:%d}/{uuid.uuid4()}.json"
    body = "\n".join(batch)  
    s3.put_object(Bucket=S3_BUCKET, Key=key, Body=body.encode("utf-8"))
    print(f"Flushed {len(batch)} records to s3://{S3_BUCKET}/{key}")

try:
    while True:
        msg = consumer.poll(timeout=1.0)
        if msg is None:
            continue
        if msg.error():
            print(f"Consumer error: {msg.error()}")
            continue

        batch.append(msg.value().decode("utf-8"))

        if len(batch) >= BATCH_SIZE:
            flush_batch(batch)
            batch = []
except KeyboardInterrupt:
    pass
finally:
    flush_batch(batch)   
    consumer.close()