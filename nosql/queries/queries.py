from pymongo.database import Database
from typing import List, Dict
from datetime import datetime, timedelta

def run_aggregation(db: Database, collection_name: str, pipeline: List[Dict]):
    result = db[collection_name].aggregate(pipeline)
    return list(result)

def user_with_most_articles():
    collection_name = "users"
    pipeline = [
        {
            "$addFields": {
                "articleCount": {"$size": "$articles"}
            }
        },
        {
            "$sort": {"articleCount": -1}
        },
        {
            "$limit": 1
        },
        {
            "$project": {
                "_id": 0,
                "name": "$user_read_only.name",
                "articleCount": 1
            }
        }
    ]
    return collection_name, pipeline


def articles_of_most_popular_author():
    collection_name = "users"
    pipeline = [
        {
            '$unwind': '$followed_users'
        }, {
            '$group': {
                '_id': '$followed_users', 
                'followers': {
                    '$sum': 1
                }
            }
        }, {
            '$sort': {
                'followers': -1
            }
        }, {
            '$limit': 1
        }, {
            '$lookup': {
                'from': 'users', 
                'localField': '_id', 
                'foreignField': '_id', 
                'as': 'userData'
            }
        }, {
            '$unwind': '$userData'
        }, {
            '$lookup': {
                'from': 'articles', 
                'localField': 'userData.articles', 
                'foreignField': '_id', 
                'as': 'articleData'
            }
        }, {
            '$project': {
                '_id': 0, 
                'followers': 1, 
                'userName': '$userData.user_read_only.name', 
                'articleTitles': '$articleData.title'
            }
        }
    ]
    return collection_name, pipeline

def longest_articles_from_last_10days():
    collection_name = "articles"
    pipeline = [
        {
            "$addFields": {
                "sectionCount": {"$size": "$sections"}
            }
        },
        {
            "$match": {
                "created_at": {
                    "$gte": datetime.utcnow() - timedelta(days=10)
                }
            }
        },
        {
            "$sort": {
                "sectionCount": -1,
                "created_at": -1
            }
        },
        {
            "$limit": 5
        },
        {
            "$project": {
                "title": 1,
                "sectionCount": 1,
                "_id": 0
            }
        }
    ]
    return collection_name, pipeline

def avg_friends():
    collection_name = "users"
    pipeline = [
        {
            '$addFields': {
                'friendCount': {
                    '$size': '$friends'
                }
            }
        }, {
            '$group': {
                '_id': None, 
                'averageFriends': {
                    '$avg': '$friendCount'
                }
            }
        }, {
            '$project': {
                '_id': 0, 
                'averageFriends': {
                    '$round': [
                        '$averageFriends', 0
                    ]
                }
            }
        }
    ]
    return collection_name, pipeline

def avg_each_reaction_per_post():
    collection_name = "reactions"
    pipline =  [
        {
            "$match": {
                "created_at": {
                    "$gte": datetime.utcnow() - timedelta(days=30)
                }
            }
        },
        {
            "$group": {
                "_id": {"post_id": "$post_id", "reaction": "$reaction"},
                "reactionCount": {"$sum": 1}
            }
        },
        {
            "$group": {
                "_id": "$_id.reaction",
                "avg": {"$avg": "$reactionCount"}
            }
        },
        {
            "$sort": {
                "avg": -1
            }
        },
        {
            "$project": {
                "_id": 0,
                "type": "$_id",
                "avg": {
                    "$round": ["$avg", 3]
                }
            }
        }
    ]
    return collection_name, pipline

def events_with_friends_going():
    collection_name = "users"
    pipline = [
        {
            '$addFields': {
                'friendCount': {
                    '$size': '$friends'
                }
            }
        }, 
        {
            '$sort': {
                'friendCount': -1
            }
        }, 
        {
            '$limit': 1
        }, 
        {
            '$lookup': {
                'from': 'events', 
                'let': {
                    'userFriends': '$friends'
                }, 
                'pipeline': [
                    {
                        '$match': {
                            '$expr': {
                                '$gt': [
                                    {
                                        '$size': {
                                            '$setIntersection': [
                                                '$members', '$$userFriends'
                                            ]
                                        }
                                    }, 0
                                ]
                            }
                        }
                    }, 
                    {
                        '$addFields': {
                            'friendsGoing': {
                                '$size': {
                                    '$setIntersection': [
                                        '$members', '$$userFriends'
                                    ]
                                }
                            }
                        }
                    }
                ], 
                'as': 'friendEvents'
            }
        }, 
        {
            '$unwind': {
                'path': '$friendEvents'
            }
        }, 
        {
            '$sort': {
                'friendEvents.friendsGoing': -1
            }
        }, 
        {
            '$limit': 10
        },
        {
            '$project': {
                '_id': 0, 
                'friendsGoing': '$friendEvents.friendsGoing', 
                'event': '$friendEvents.name'
            }
        }
    ]
    return collection_name, pipline

def users_with_mutual_friends():
    collection_name = "users"
    pipline = [
        {
            '$addFields': {
                'friendCount': {
                    '$size': '$friends'
                }
            }
        }, {
            '$sort': {
                'friendCount': -1
            }
        }, {
            '$limit': 1
        }, {
            '$lookup': {
                'from': 'users', 
                'let': {
                    'userId': '$_id', 
                    'userFriends': '$friends'
                }, 
                'pipeline': [
                    {
                        '$match': {
                            '$expr': {
                                '$and': [
                                    {
                                        '$ne': [
                                            '$_id', '$$userId'
                                        ]
                                    }, {
                                        '$not': {
                                            '$in': [
                                                '$_id', '$$userFriends'
                                            ]
                                        }
                                    }, {
                                        '$gt': [
                                            {
                                                '$size': {
                                                    '$setIntersection': [
                                                        '$friends', '$$userFriends'
                                                    ]
                                                }
                                            }, 0
                                        ]
                                    }
                                ]
                            }
                        }
                    }, {
                        '$addFields': {
                            'mutualFriends': {
                                '$size': {
                                    '$setIntersection': [
                                        '$friends', '$$userFriends'
                                    ]
                                }
                            }
                        }
                    }
                ], 
                'as': 'friendFriends'
            }
        }, {
            '$unwind': {
                'path': '$friendFriends'
            }
        }, {
            '$sort': {
                'friendFriends.mutualFriends': -1
            }
        }, 
        {
            '$limit': 10
        },
        {
            '$project': {
                '_id': 0, 
                'mutualFriends': '$friendFriends.mutualFriends', 
                'name': '$friendFriends.user_read_only.name'
            }
        }
    ]
    return collection_name, pipline

def tags_most_viewed():
    collection_name = "pages"
    pipline = [
        {
            '$unwind': {
                'path': '$tags'
            }
        }, {
            '$group': {
                '_id': '$tags', 
                'avgViews': {
                    '$avg': '$views'
                }, 
                'avgLikes': {
                    '$avg': {
                        '$size': '$likes'
                    }
                }
            }
        }, {
            '$sort': {
                'avgViews': -1, 
                'avgLikes': -1
            }
        },
        {
            '$limit': 5
        },
        {
            '$project': {
                '_id': 0,
                'tag': '$_id',
                'avgViews': {
                    '$round': ['$avgViews', 0]
                },
                'avgLikes': {
                    '$round': ['$avgLikes', 0]
                }
            }
        }
    ]
    return collection_name, pipline

def user_with_most_avg_reactions_per_post():
    collection_name = "reactions"
    pipline = [
        {
            '$group': {
                '_id': '$post_id', 
                'reactionsCount': {
                    '$sum': 1
                }
            }
        }, {
            '$sort': {
                'reactionsCount': -1
            }
        }, {
            '$lookup': {
                'from': 'users', 
                'let': {
                    'postId': '$_id'
                }, 
                'pipeline': [
                    {
                        '$match': {
                            '$expr': {
                                '$in': [
                                    '$$postId', '$posts'
                                ]
                            }
                        }
                    }
                ], 
                'as': 'postAuthorData'
            }
        }, {
            '$group': {
                '_id': {
                    'id': '$postAuthorData._id', 
                    'name': '$postAuthorData.user_read_only.name'
                }, 
                'avgReactionsPerPost': {
                    '$avg': '$reactionsCount'
                }
            }
        }, {
            '$sort': {
                'avgReactionsPerPost': -1
            }
        }, {
            '$limit': 1
        }, {
            '$project': {
                '_id': 0, 
                'name': '$_id.name', 
                'avgReactionsPerPost': 1
            }
        }
    ]
    return collection_name, pipline

def last_message_from_conversation():
    collection_name = "users"
    pipline = [
        {
            '$sort': {
                'user_read_only.name': 1
            }
        }, {
            '$limit': 1
        }, {
            '$project': {
                'conversations': 1
            }
        }, {
            '$unwind': {
                'path': '$conversations'
            }
        }, {
            '$lookup': {
                'from': 'conversations', 
                'localField': 'conversations', 
                'foreignField': '_id', 
                'as': 'conversationData'
            }
        }, {
            '$unwind': {
                'path': '$conversationData'
            }
        }, {
            '$unwind': {
                'path': '$conversationData.message'
            }
        }, {
            '$project': {
                'conversationId': '$conversationData._id', 
                'conversationName': '$conversationData.title', 
                'message': '$conversationData.message'
            }
        }, {
            '$sort': {
                'message.created_at': -1
            }
        }, {
            '$group': {
                '_id': {
                    'convId': '$conversationId', 
                    'convName': '$conversationName'
                }, 
                'lastMessage': {
                    '$first': '$message'
                }
            }
        }, 
        {
            '$sort': {
                'lastMessage.created_at': -1
            }
        }, {
            '$limit': 5
        },
        {
            '$project': {
                '_id': 0,
                'conversationTitle': '$_id.convName',
                'lastMessage': {
                    '$concat': [
                        {'$arrayElemAt': [
                            {'$split': [{'$ifNull': ['$lastMessage.content', '']}, ' ']}, 0
                        ]},
                        ' ',
                        {'$arrayElemAt': [
                            {'$split': [{'$ifNull': ['$lastMessage.content', '']}, ' ']}, 1
                        ]},
                        ' ',
                        {'$arrayElemAt': [
                            {'$split': [{'$ifNull': ['$lastMessage.content', '']}, ' ']}, 2
                        ]}
                    ]
                }
            }
        }
    ]
    return collection_name, pipline