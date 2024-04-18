import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/database/reviewDao.dart';
import 'package:ciak_time/database/reviewData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class InsertReview extends StatefulWidget {
  const InsertReview({Key key, @required this.title, @required this.movieId})
      : super(key: key);

  final String title;
  final int movieId;

  @override
  _InsertReviewState createState() => _InsertReviewState();
}

class _InsertReviewState extends State<InsertReview> {
  FutureOr onGoBack(dynamic value) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    if (args.fromWhere == "/insertreviewfromreviews" && noPressed == false) {
      Navigator.pop(context);
    }
    if (args.fromWhere == "/insertreviewfrommovie" && noPressed == false) {
      Navigator.popAndPushNamed(context, "/reviewslist");
    }
  }

  final TextEditingController reviewController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  Color color;
  @override
  Widget build(BuildContext context) {
    _focusNode.addListener(() {
      setState(() {
        color = _focusNode.hasFocus ? Colors.blue : Colors.red;
      });
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Row(children: [
            Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            
          ]),
        ),
        leadingWidth: 40,
        title: Text(
          language.review_movie,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              Text(
                language.rate,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Quicksand',
                  fontSize: width * 0.05,
                  color: themePrimaryColor,
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Center(
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: width * 0.1,
                  unratedColor: ratingColor,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      newRating = rating;
                    });
                  },
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Container(
                width: width * 0.8,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      review = value;
                    });
                  },
                  controller: reviewController,
                  focusNode: _focusNode,
                  maxLines: 10,
                  cursorColor: themePrimaryColor,
                  decoration: InputDecoration(
                    focusedBorder: new OutlineInputBorder(
                        borderSide: new BorderSide(color: themePrimaryColor)),
                    border: OutlineInputBorder(),
                    focusColor: themePrimaryColor,
                    labelText: language.write_review,
                    labelStyle: TextStyle(
                      color: _focusNode.hasFocus
                          ? themePrimaryColor
                          : themeDividerColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    color: changeSaveColor(),
                    onPressed: () {
                      if (reviewController.text.isNotEmpty && newRating != 0) {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return ConfirmReview(
                              reviewController: reviewController,
                              movieId: widget.movieId,
                            );
                          },
                        ).then(onGoBack);
                      } else {
                        if (reviewController.text.isEmpty) {
                          showOkAlertDialog(
                              context: context,
                              title: language.empty_review_alert);
                        } else if (newRating == 0) {
                          showOkAlertDialog(
                              context: context,
                              title: language.empty_rating_alert);
                        }
                      }
                    },
                    child: Text(
                      language.save,
                      style: TextStyle(
                        color: changeSaveTextColor(),
                        fontSize: width * 0.05,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color changeSaveColor() {
    setState(() {
      if (reviewController.text.isNotEmpty && newRating != 0) {
        saveColor = themePrimaryColor;
      } else {
        saveColor = themeSecondaryColor;
      }
    });
    return saveColor;
  }

  Color changeSaveTextColor() {
    setState(() {
      if (reviewController.text.isNotEmpty && newRating != 0) {
        saveTextColor = loginRegisterColor;
      } else {
        saveTextColor = Colors.grey;
      }
    });
    return saveTextColor;
  }
}

class ConfirmReview extends StatelessWidget {
  const ConfirmReview({
    Key key,
    @required this.reviewController,
    @required this.movieId,
  }) : super(key: key);
  final TextEditingController reviewController;
  final int movieId;

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                language.publish_review_alert,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.02,
                  fontFamily: 'Quicksand',
                ),
              ),
              SizedBox(
                height: height * 0.028,
              ),
              Container(
                width: width * 0.7,
                height: height * 0.03,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(width * 0.1, height * 0.005),
                        padding: EdgeInsets.all(0.0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        noPressed = true;
                      },
                      child: Text(
                        language.no,
                        style: TextStyle(
                          color: themeDialogPrimaryColor,
                          fontSize: height * 0.02,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(width * 0.1, height * 0.005),
                        padding: EdgeInsets.all(0.0),
                      ),
                      onPressed: () async {
                        noPressed = false;
                        final reviewDao = ReviewDao();
                        final reviewData = ReviewData(
                            userId,
                            movieId,
                            profilePicUrl,
                            userlogged,
                            review,
                            newRating,
                            0,
                            0,
                            "en");
                        await reviewDao.saveReview(reviewData);
                        Navigator.pop(context);
                      },
                      child: Text(
                        language.yes,
                        style: TextStyle(
                          color: themePrimaryColor,
                          fontSize: height * 0.02,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
