db.users.aggregate[
  ({
    $addFields: {
      friendCount: { $size: '$friends' }
    }
  },
  {
    $group: {
      _id: null,
      averageFriends: { $avg: '$friendCount' }
    }
  },
  {
    $project: {
      _id: 0,
      averageFriends: { $round: ['$averageFriends', 0] }
    }
  })
]
