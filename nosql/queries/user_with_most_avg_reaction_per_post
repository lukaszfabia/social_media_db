db.reactions.aggregate
[
  {
	$group: {
  	_id: "$post_id",
  	reactionsCount: {
    	$sum: 1
  	}
	}
  },
  {
	$sort: {
  	"reactionsCount": -1
	}
  },
	{
	$lookup: {
  	from: "users",    	 
  	let: {
    	postId: "$_id"
  	},
  	pipeline: [
    	{
      	$match: {
        	$expr: {
        	$in: ["$$postId", "$posts"] }
    	}
    	}
  	],
  	as: "postAuthorData" }
  },
  {
	$group: {
  	_id:{
    	id: "$postAuthorData._id",
    	name: "$postAuthorData.user_read_only.name"
  	},
  	avgReactionsPerPost: {
    	$avg: "$reactionsCount"
  	}
	}
  },
  {
	$sort: {"avgReactionsPerPost": -1}
  },
  {
	$limit: 1
  },
  {
	$project: {
  	_id: 0,
  	name: "$_id.name",
  	avgReactionsPerPost: 1
	}
  }

]
