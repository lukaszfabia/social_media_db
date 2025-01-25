db.pages.aggregate
[
  {
	$unwind: {
  	path: "$tags"
	}
  },
  {
	$group: {
  	_id: "$tags",
  	avgViews: {
    	$avg: "$views"
  	},
  	avgLikes: {
    	$avg: {
      	$size: "$likes"
    	}
  	}
	}
  },
  {
	$sort: {
  	avgViews: -1,
  	avgLikes: -1
	}
  }
]
