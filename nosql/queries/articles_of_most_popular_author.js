db.users.aggregate[
	{
	  $unwind: "$followed_users"
	  },
	{
	  $group: {
		_id: "$followed_users",
		followers: { $sum: 1}
	  }
	},
	{
	  $sort: {
		followers: -1
	  }
	},
	{
	  $limit: 1
	},
	{
	  $lookup: {
		from: "users",
		localField: "_id",
		foreignField: "_id",
		as: "userData"
	  }
	},
	{
		  $unwind: "$userData"
	},
	{
	  $lookup: {
		from: "articles",
		localField: "userData.articles",
		foreignField: "_id",
		as: "articleData"
	  }
	},
	{
	  $project: {
		followers: 1,
		userName: "$userData.user_read_only.name",
		articleTitle: "$articleData.title",
	  }
	}
]
  