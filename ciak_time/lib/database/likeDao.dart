import 'package:ciak_time/database/likeData.dart';
import 'package:firebase_database/firebase_database.dart';

class LikeDao {
  final DatabaseReference _likesRef =
      FirebaseDatabase.instance.reference().child('likes');

  void saveLike(LikeData likeData) {
    _likesRef.push().set(likeData.toJson());
  } 
}