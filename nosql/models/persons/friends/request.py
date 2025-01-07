from model import Model
from bson import ObjectId
from ...enums import FriendRequestStatus


class FriendRequest(Model):
    sender_id: ObjectId
    receiver_id: ObjectId
    status: FriendRequestStatus = FriendRequestStatus.Pending
