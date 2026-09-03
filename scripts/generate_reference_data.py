# scripts/generate_reference_data.py
import csv
import random
from datetime import datetime, timedelta
from faker import Faker

fake = Faker()
random.seed(42)  # reproducible output — same data every run, useful for consistent testing

# ---- Accounts (supports SCD Type 2 later) ----
ACCOUNT_TIERS = ["basic", "premium", "gold"]
ACCOUNT_STATUSES = ["active", "suspended", "closed"]

def generate_accounts(n=50):
    accounts = []
    for i in range(1, n + 1):
        open_date = fake.date_between(start_date="-5y", end_date="-30d")
        accounts.append({
            "account_id": f"acc-{i}",
            "customer_name": fake.name(),
            "account_tier": random.choices(ACCOUNT_TIERS, weights=[0.6, 0.3, 0.1])[0],
            "account_status": random.choices(ACCOUNT_STATUSES, weights=[0.85, 0.1, 0.05])[0],
            "open_date": open_date.isoformat(),
            "country": fake.country_code(),
        })
    return accounts


# ---- Merchants ----
MERCHANT_CATEGORIES = ["grocery", "travel", "electronics", "restaurant", "utilities"]

def generate_merchants(n=20):
    merchants = []
    for i in range(1, n + 1):
        merchants.append({
            "merchant_id": f"merch-{i}",
            "merchant_name": fake.company(),
            "merchant_category": random.choice(MERCHANT_CATEGORIES),
            "country": fake.country_code(),
        })
    return merchants


# ---- Exchange rates (dated, for currency-normalization join) ----
CURRENCIES = ["USD", "EUR", "GBP", "EGP"]
BASE_RATES_TO_USD = {"USD": 1.0, "EUR": 1.08, "GBP": 1.27, "EGP": 0.021}

def generate_exchange_rates(days_back=30):
    rates = []
    today = datetime.utcnow().date()
    for d in range(days_back):
        date = today - timedelta(days=d)
        for currency in CURRENCIES:
            # small daily jitter around the base rate, for realism
            jitter = random.uniform(-0.01, 0.01)
            rate = round(BASE_RATES_TO_USD[currency] * (1 + jitter), 6)
            rates.append({
                "currency": currency,
                "rate_to_usd": rate,
                "effective_date": date.isoformat(),
            })
    return rates


def write_csv(filename, rows, fieldnames):
    with open(filename, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)
    print(f"Wrote {len(rows)} rows to {filename}")


if __name__ == "__main__":
    accounts = generate_accounts()
    merchants = generate_merchants()
    rates = generate_exchange_rates()

    write_csv("accounts.csv", accounts,
              ["account_id", "customer_name", "account_tier", "account_status", "open_date", "country"])
    write_csv("merchants.csv", merchants,
              ["merchant_id", "merchant_name", "merchant_category", "country"])
    write_csv("exchange_rates.csv", rates,
              ["currency", "rate_to_usd", "effective_date"])