import 'package:ciak_time/database/userData.dart';
import 'package:firebase_database/firebase_database.dart';

class UserDao {
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.reference().child('users');

  void saveUser(UserData userData) {
    _usersRef.push().set(userData.toJson());
  }
}
