from database.connect import MongoDB

if __name__ == "__main__":
    client = MongoDB()

    client.health()
