from enum import Enum


class AuthorType(str, Enum):
    Page: str = "page"
    User: str = "user"


class FriendRequestStatus(str, Enum):
    Pending: str = "pending"
    Rejected: str = "rejected"
    Accepted: str = "accepted"


class UserPrivilege(str, Enum):
    Mod: str = "mod"
    Admin: str = "admin"
    User: str = "user"
