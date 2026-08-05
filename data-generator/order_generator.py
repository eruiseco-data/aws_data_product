import requests
import random
from datetime import datetime, UTC

class OrderGenerator:
    def __init__(self):
        try:
            print("Calling API to load all products...")
            response = requests.get(f"https://fakestoreapi.com/products")
            if response.status_code == 200:
                self.all_products = response.json()
            else:
                raise Exception(response.status_code)
        except Exception as e:
            print(f"Exception ocurred while calling fakestore api")
            print(e)

    def generate_order(self):
        data = random.choice(self.all_products)
        order = {
            "order_id": random.randint(100000,999999),
            "customer_id": random.randint(1,500),
            "product_id": data.get("id"),
            "product_title": data.get("title"),
            "quantity": random.randint(1,5),
            "unit_price": data.get("price"),
            "timestamp": datetime.now(UTC).isoformat(),
            "status": random.choice(["pending","completed","cancelled"])
        }
        return order

    def generate_batch(self,count=10):
        print("Generating Orders...")
        return [self.generate_order() for _ in range(count)]