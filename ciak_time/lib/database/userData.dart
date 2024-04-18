class UserData {
  final String email;
  final String username;
  final String imgUrl;
  final String uid;
  final String password;

  UserData(this.email, this.username, this.imgUrl, this.uid, this.password);

  UserData.fromJson(Map<dynamic, dynamic> json)
      : email = json["email"] as String,
        imgUrl = json['imgUrl'] as String,
        username = json['username'] as String,
        uid = json['uid'] as String,
        password = json['password'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'email': email,
        'imgUrl': imgUrl,
        'username': username,
        'uid': uid,
        'password': password,
      };
}
