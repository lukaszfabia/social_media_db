db.users.aggregate
[
  {
  	$addFields: {
    	friendCount: { $size: "$friends" }
  	}
  },
  {
	$sort: {
  	    friendCount: -1
	}
  },
  {
	$limit: 1
  },
  {
	$lookup: {
  	from: "users",    	 
  	let: {
    	userId: "$_id",
    	userFriends: "$friends"
  	},
  	pipeline: [
    	{
            $match: {
                $expr: {
                $and: [
                    { $ne: ["$_id", "$$userId"] },
                    { $not: { $in: ["$_id", "$$userFriends"] } },
                    {$gt: [ { $size: { $setIntersection: ["$friends", "$$userFriends"] } }, 0 ]}
                ]
                }
            }
    	},
    	{
            $addFields:{
                mutualFriends: { $size: { $setIntersection: ["$friends", "$$userFriends"] } }
            }
    	}
  	],
  	as: "friendFriends" }
  },
  {
	$unwind: {
  	path: "$friendFriends"
	}
  },
  {
	$sort:
  	{"friendFriends.mutualFriends": -1}
  },
  {
	$project: {
  	_id: 0,
  	mutualFriends: "$friendFriends.mutualFriends",
  	name: "$friendFriends.user_read_only.name"
	}
  }
]
