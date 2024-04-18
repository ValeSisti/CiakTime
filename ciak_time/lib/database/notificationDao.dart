
import 'package:ciak_time/database/notificationData.dart';
import 'package:firebase_database/firebase_database.dart';

class NotificationDao {
  final DatabaseReference _notificationRef =
      FirebaseDatabase.instance.reference().child('notifications');

  void saveNotification(NotificationData notificationData) {
    _notificationRef.push().set(notificationData.toJson());
  }
}