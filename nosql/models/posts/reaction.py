from ..model import Model
from enum import Enum
from ..persons.user import UserReadOnly
from bson import ObjectId


class ReactionType(str, Enum):
    Like = "like"
    Love = "love"
    Haha = "haha"
    Wow = "wow"
    Sad = "sad"
    Angry = "angry"


REACTION_TYPE_LIST = [reaction.value for reaction in ReactionType]


class Reaction(Model):
    user: UserReadOnly
    post_id: ObjectId
    reaction: ReactionType
