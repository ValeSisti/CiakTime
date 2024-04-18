import 'package:ciak_time/database/reviewData.dart';
import 'package:firebase_database/firebase_database.dart';

class ReviewDao {
  final DatabaseReference _reviewRef =
      FirebaseDatabase.instance.reference().child('reviews');

  void saveReview(ReviewData reviewData) {
    _reviewRef.push().set(reviewData.toJson());
  }
}
