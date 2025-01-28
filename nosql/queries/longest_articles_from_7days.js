db.articles.aggregate[
    {
      $addFields: {
        sectionCount: {$size: "$sections"}
      }
    },
    {
      $match: {
        created_at: {
          $gte: new Date(new Date().setDate(new Date().getDate()-7))
        }
      }
    },
    {
      $sort: {
        sectionCount: -1,
        created_at: -1
      }
    },
    {
      $limit: 5
    },
    {
      $project: {
        _id: 0,
        title: 1,
        sectionCount: 1,
        created_at: 1
      }
    }
   
  ]
  