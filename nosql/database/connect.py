from pymongo import MongoClient
from dotenv import load_dotenv
import os
from pathlib import Path


class MongoDB:

    def __init__(self):
        path = Path(__file__).parent.parent / ".env"

        load_dotenv(path)
        uri: str = os.getenv("MONGO_URI")

        if uri is None:
            raise ValueError("Please provide valid .env")

        self._client = MongoClient(uri)

    @property
    def db(self) -> MongoClient:
        """
        Get instance of mongos client
        """
        return self._client

    def health(self):
        """Checks connection with db"""
        try:
            self._client.admin.command("ping")
            print("Successfully connected to MongoDB!")
        except Exception as e:
            print(e)
