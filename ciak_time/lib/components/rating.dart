import 'dart:async';
import 'package:ciak_time/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: 0,
      minRating: 0.5,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: width * 0.1,
      unratedColor: Colors.grey[400],
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        newRating = rating;
      },
    );
  }
}

class RatingUnclickable extends StatelessWidget {
  const RatingUnclickable({
    Key key,
    @required this.unratedColor,
    @required this.rate,
    @required this.size,
  }) : super(key: key);

  final Color unratedColor;
  final double rate;
  final double size;

  @override
  Widget build(BuildContext context) {
    double value;

    if (rate == null || rate == 0.0) {
      value = 0.0;
    } else {
      value = rate;
    }

    return RatingBarIndicator(
      rating: value,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: size,
      unratedColor: unratedColor,
      direction: Axis.horizontal,
    );
  }
}

class RatingUnclickable2 extends StatefulWidget {
  const RatingUnclickable2({
    Key key,
    @required this.unratedColor,
    @required this.rating,
  }) : super(key: key);

  final Color unratedColor;
  final double rating;

  @override
  State<RatingUnclickable2> createState() => _RatingUnclickable2State();
}

class _RatingUnclickable2State extends State<RatingUnclickable2> {
  @override
  Widget build(BuildContext context) {
    double value;

    if (widget.rating == null || widget.rating == 0.0) {
      value = 0.0;
    } else {
      value = widget.rating;
    }

    return RatingBarIndicator(
      rating: value,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: 25.0,
      unratedColor: widget.unratedColor,
      direction: Axis.horizontal,
    );
  }
}

Future<double> getRating(id) async {
  var db = FirebaseDatabase.instance.reference().child("reviews");
  DataSnapshot snapshotto = await db.once();
  Map<dynamic, dynamic> values = snapshotto.value;

  double rating = 0.0;
  double total = 0.0;
  int count = 0;

  if (values != null) {
    values.forEach((key, value) {
      if (value["movieId"] == id) {
        total = total + value["rating"].toDouble();
        count = count + 1;
      }
    });

    if (total != 0.0) {
      rating = total / count;
    }
  }
  return rating;
}
