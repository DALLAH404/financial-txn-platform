import argparse
import time
from datetime import datetime, timedelta

from generator import generate_transaction


def parse_args():
    parser = argparse.ArgumentParser(description="Fake transaction event producer")
    parser.add_argument(
        "--interval", type=float, default=2.0,
        help="Seconds to wait between events (default: 2.0)"
    )
    parser.add_argument(
        "--max-events", type=int, default=None,
        help="Stop after generating this many events (default: unlimited)"
    )
    parser.add_argument(
        "--duration", type=int, default=None,
        help="Stop after this many seconds (default: unlimited)"
    )
    return parser.parse_args()


def main():
    args = parse_args()
    start_time = datetime.now()
    count = 0

    while True:
        if args.max_events is not None and count >= args.max_events:
            print(f"Reached max-events limit ({args.max_events}), stopping.")
            break

        if args.duration is not None and (datetime.now() - start_time) >= timedelta(seconds=args.duration):
            print(f"Reached duration limit ({args.duration}s), stopping.")
            break

        txn = generate_transaction()
        print(txn.model_dump_json(indent=2))
        count += 1
        time.sleep(args.interval)

    print(f"Generated {count} events total.")


if __name__ == "__main__":
    main()