 db.reactions.aggregate[
  {
	$match: {
  	created_at: {
        	$gte: new Date(new Date().setDate(new Date().getDate()-30))
      	}
	}
  },
  {
	$group: {
  	_id:  {post_id: "$post_id", reaction: "$reaction"},
  	reactionCount: {$sum: 1}
  	}
  },
  {
	$group: {
  	_id: "$_id.reaction",
  	avg: {
    	$avg: "$reactionCount"
  	}
	}
  },
  {
	$sort: {
  	avg: -1
	}
  },
  {
	$project: {
  	_id: 0,
  	type: "$_id",
  	avg: {
    	$round: ["$avg", 3]
  	}
	}
  }
]
