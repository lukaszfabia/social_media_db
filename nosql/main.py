from database.connect import MongoDB
import uuid
from seeder import seed

if __name__ == "__main__":
    client = MongoDB()

    client.health()

    seed(client.db)
