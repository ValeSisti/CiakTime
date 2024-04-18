class NotificationData {
  final String userIdReceiver;
  final String usernameSender;
  final int movieId;
  final String reaction;

  NotificationData(
      this.userIdReceiver, this.usernameSender, this.movieId, this.reaction);

  NotificationData.fromJson(Map<dynamic, dynamic> json)
      : userIdReceiver = json['userIdReceiver'] as String,
        usernameSender = json['usernameSender'] as String,
        movieId = json['movieId'] as int,
        reaction = json['reaction'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'userIdReceiver': userIdReceiver,
        'usernameSender': usernameSender,
        'movieId': movieId,
        'reaction': reaction,
      };
}
