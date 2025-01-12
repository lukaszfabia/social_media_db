from pymongo import MongoClient
from pymongo.database import Database
from dotenv import load_dotenv
import os
from pathlib import Path


class MongoDB:
    def __init__(self) -> None:
        path: Path = Path(__file__).parent.parent / ".env"

        load_dotenv(path)
        uri: str | None = os.getenv("MONGO_URI")
        self.__db_name: str | None = os.getenv("DATABASE_NAME")

        if self.__db_name is None:
            raise ValueError("Please provide DATABASE_NAME")

        if uri is None:
            # build uri
            username: str | None = os.getenv("USERNAME")
            password: str | None = os.getenv("PASSWORD")

            if username and password:
                uri = f'mongodb+srv://{os.getenv("USERNAME")}:{os.getenv(
                    "PASSWORD")}@cluster0.gheyk.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0'

            else:
                raise ValueError(
                    "Please provide entire URI or PASSWORD and USERNAME")

        self.__client: MongoClient = MongoClient(uri)
        self.__db: Database = self.__client[self.__db_name]

    @property
    def client(self) -> MongoClient:
        """
        Get instance of mongos client
        """
        return self.__client

    @property
    def db(self) -> Database:
        """Get instance of mongos db

        Returns:
            Database: db
        """
        return self.__db

    def health(self) -> None:
        """Checks connection with db"""
        try:
            self.__client.admin.command("ping")
            print("Successfully connected to MongoDB!")
        except Exception as e:
            print(e)
