from database.connect import MongoDB
import uuid

if __name__ == "__main__":
    client = MongoDB()

    client.health()
