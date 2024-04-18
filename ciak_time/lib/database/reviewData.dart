class ReviewData {
  final String userId;
  final int movieId;
  final String userPic;
  final String username;
  final String review;
  final double rating;
  final int likes;
  final int dislikes;
  final String language;

  ReviewData(this.userId, this.movieId, this.userPic, this.username,
      this.review, this.rating, this.likes, this.dislikes, this.language);

  ReviewData.fromJson(Map<dynamic, dynamic> json)
      : userId = json['userId'] as String,
        movieId = json['movieId'] as int,
        userPic = json['userPic'] as String,
        username = json['username'] as String,
        review = json['review'] as String,
        rating = json['rating'] as double,
        likes = json['likes'] as int,
        dislikes = json['dislikes'] as int,
        language = json['language'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'userId': userId,
        'movieId': movieId,
        'userPic': userPic,
        'username': username,
        'review': review,
        'rating': rating,
        'likes': likes,
        'dislikes': dislikes,
        'language': language,
      };
}
