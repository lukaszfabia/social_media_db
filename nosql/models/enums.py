from enum import Enum


class AuthorType(str, Enum):
    Page = "page"
    User = "user"


class FriendRequestStatus(str, Enum):
    Pending = "pending"
    Rejected = "rejected"
    Accepted = "accepted"


class UserPrivilege(str, Enum):
    Mod = "mod"
    Admin = "admin"
    User = "user"
