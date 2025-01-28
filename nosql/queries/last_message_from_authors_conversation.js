db.users.aggregate
[
	{
		$addFields: {
			conversationCount: {$size: "$conversations"}
		}
	},
  {
	$sort:{
    	"conversationCount": -1
	}
  },
  {
	$limit: 1
  },
  {
	$project: {
  	conversations: 1
	}
  },
  {
	$unwind: {
  	path: "$conversations"
	}
  },
  {
	$lookup: {
  	from: "conversations",
  	localField:"conversations",
  	foreignField: "_id",
  	as: "conversationData"
	}
  },
  {
	$unwind: {
  	path: "$conversationData"
	}
  },
  {
	$unwind: {
  	path: "$conversationData.message"
	}
  },
  {
	$project: {
  	conversationId: "$conversationData._id",
  	conversationName: "$conversationData.title",
  	message: "$conversationData.message"
  	}
  },
  {
	$sort:
  	{"message.created_at": -1}
  },
  {
	$group: {
  	_id: {
    	convId: "$conversationId",
    	convName:  "$conversationName"
  	},
  	lastMessage: {
    	$first: "$message"
  	}
	}
  },
  {
	$project: {
  	_id: 0,
  	conversationTitle: "$_id.convName",
  	lastMessage: "$lastMessage.content",
  	time: "$lastMessage.created_at"
   }
  },
  {
	$sort: {
  	time: -1
	}
  },
  {
	$limit: 10
  }  
]
