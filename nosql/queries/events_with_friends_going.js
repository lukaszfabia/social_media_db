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
  	from: "events",    	 
  	let: { userFriends: "$friends" },
  	pipeline: [
    	{
      	$match: {
        	$expr: {
          	$gt: [ { $size: { $setIntersection: ["$members", "$$userFriends"] } }, 0 ]
        	}
      	}
    	},
    	{
      	$addFields:{
        	friendsGoing: { $size: { $setIntersection: ["$members", "$$userFriends"] } }
      	}
    	}
  	],
  	as: "friendEvents" }
  },
  {
	$unwind: {
  		path: "$friendEvents"
	}
  },
  {
	$sort: {"friendEvents.friendsGoing": -1}
  },
  {
	$project: {
		_id: 0,
		friendsGoing: "$friendEvents.friendsGoing",
		event: "$friendEvents.name"
	}
  }

]
