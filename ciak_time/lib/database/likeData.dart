class LikeData {
  final String userId;
  final String reviewId;
  final bool liked;
  final bool disliked;

  LikeData(this.userId, this.reviewId, this.liked, this.disliked);

  LikeData.fromJson(Map<dynamic, dynamic> json)
      : userId = json['userId'] as String,
        reviewId = json['movieId'] as String,
        liked = json['liked'] as bool,
        disliked = json['disliked'] as bool;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'userId': userId,
        'reviewId': reviewId,
        'liked':liked,
        'disliked': disliked
      };
}