import 'package:ciak_time/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key key,
  }) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);

        isFromGallery = true;
        uploadImageToFirebase();
      } else {}
    });
  }

  Future<void> uploadImageToFirebase() async {
    try {
      firebase_storage.UploadTask task = firebase_storage
          .FirebaseStorage.instance
          .ref('uploads/' + userId + ".png")
          .putFile(image);
      firebase_storage.TaskSnapshot taskSnapshot = await task;
      taskSnapshot.ref.getDownloadURL().then((value) async {
        setState(() {
          profilePicUrl = value;
        });
        
        var db = FirebaseDatabase.instance.reference().child("users");
        DataSnapshot snapshot = await db.once();
        Map<dynamic, dynamic> values = snapshot.value;
        if (values != null) {
          values.forEach((key, value) {
            if (value["uid"] == userId) {
              FirebaseDatabase.instance
                  .reference()
                  .child("users/" + key)
                  .update({"imgUrl": profilePicUrl});
            }
          });
        }

        var revDb = FirebaseDatabase.instance.reference().child("reviews");
        DataSnapshot revSnapshot = await revDb.once();
        Map<dynamic, dynamic> revValues = revSnapshot.value;
        if (revValues != null) {
          revValues.forEach((key, value) {
            if (value["userId"] == userId) {
              FirebaseDatabase.instance
                  .reference()
                  .child("reviews/" + key)
                  .update({"userPic": profilePicUrl});
            }
          });
        }
      });
    } on firebase_core.FirebaseException catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        overflow: Overflow.visible,
        children: [
          getCircleAvatar(isFromGallery),
          Positioned(
            right: -20,
            bottom: 0,
            child: SizedBox(
              height: height * 0.07,
              width: height * 0.07,
              child: Column(
                children: [
                  Container(
                    height: height * 0.07,
                    width: height * 0.07,
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: themePrimaryColor),
                        ),
                        color: themePrimaryColor,
                        onPressed: () {
                          getImage();
                        },
                        child: Icon(
                          Icons.photo_camera_outlined,
                          color: themeIconColor,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

CircleAvatar getCircleAvatar(bool isFromGallery) {
  profilePicture = CircleAvatar(
    backgroundImage: NetworkImage(profilePicUrl),
    backgroundColor: Colors.white,
    radius: height * 0.08,
  );

  return profilePicture;
}
