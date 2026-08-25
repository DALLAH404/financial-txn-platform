from generator import generate_transaction
import time

if __name__ == "__main__":

    while(1):
        txn = generate_transaction()
        print(txn.model_dump_json(indent=2))
        time.sleep(2)

