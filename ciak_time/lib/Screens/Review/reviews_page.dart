import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ciak_time/Screens/Review/review_object.dart';
import 'package:ciak_time/blocs/movie_reviews_bloc.dart';
import 'package:ciak_time/components/rating.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/database/likeDao.dart';
import 'package:ciak_time/database/likeData.dart';
import 'package:ciak_time/database/notificationDao.dart';
import 'package:ciak_time/database/notificationData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readmore/readmore.dart';

class ReviewsPage extends StatefulWidget {
  final String title;
  final int movieId;

  const ReviewsPage({
    Key key,
    @required this.title,
    @required this.movieId,
  }) : super(key: key);

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

var subscription;
ScrollController _controller = ScrollController(keepScrollOffset: true);
Function stfBuildSetState;
Widget _newReviewFloatingButton = Container();
Widget newReviewBtn = StatefulBuilder(
  builder: (BuildContext context, setState) {
    stfBuildSetState = setState;
    return _newReviewFloatingButton;
  },
);

class _ReviewsPageState extends State<ReviewsPage> {
  bool _reviewInDb = false;
  bool initialDataLoaded = false;
  StreamSubscription<Event> _listener;

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  MovieReviewsBloc bloc;

  @override
  void initState() {
    bloc = MovieReviewsBloc(widget.movieId.toString());
    bloc.fetchMovieReviewsResults();

    super.initState();

    var ref = FirebaseDatabase.instance.reference();

    _listener = ref.child('reviews').onChildAdded.listen((event) {
      if (initialDataLoaded) {
        if (event.snapshot.value["movieId"] == widget.movieId &&
            event.snapshot.value["userId"] != userId) {
          stfBuildSetState(() {
            _newReviewFloatingButton = Positioned(
              left: width * 0.1,
              right: width * 0.1,
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Container(
                    height: 30,
                    child: FloatingActionButton.extended(
                        backgroundColor: Colors.amber,
                        label: Container(
                          child: Row(
                            children: [
                              Icon(Icons.arrow_upward),
                              SizedBox(
                                width: 10,
                              ),
                              Text(language.new_review_button,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Quicksand-Medium',
                                  )),
                            ],
                          ),
                        ),
                        onPressed: () {
                          setState(() {});
                          stfBuildSetState(() {
                            _newReviewFloatingButton = Container();
                          });
                          _controller.animateTo(
                            _controller.position.minScrollExtent,
                            duration: Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                          );
                        }),
                  ),
                ],
              ),
            );
          });
        }
        return newReviewBtn;
      }
    });
    ref.once().then((value) {
      initialDataLoaded = true;
    });
  }

  @override
  void dispose() {
    _newReviewFloatingButton = Container();
    _listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        actions: <Widget>[
          Container(
            width: width * 0.28,
            child: TextButton(
              onPressed: () async {
                await reviewInDb(widget.movieId).then((value) {
                  setState(() {
                    _reviewInDb = value;
                  });
                  if (_reviewInDb) {
                    showOkAlertDialog(
                        context: context, title: language.review_yet);
                  } else {
                    Navigator.pushNamed(context, '/insertreviewfromreviews',
                            arguments:
                                ScreenArguments('/insertreviewfromreviews'))
                        .then((_) {
                      setState(() {});
                    });
                  }
                });
              },
              child: Text(
                language.add_review,
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ),
        ],
        title: Text(
          language.reviews,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<List<ReviewObject>>(
              future: getReviewsList(widget.movieId),
              builder: (context, AsyncSnapshot<List<ReviewObject>> snapshot) {
                if (snapshot.hasData) {
                  return getBody(snapshot, onGoBack, widget.movieId);
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    language.no_review,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: height * 0.022,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand'),
                  ));
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            newReviewBtn,
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<List<ReviewObject>> getReviewsList(int movieId) async {
    List<ReviewObject> reviewsList = [];
    var db = FirebaseDatabase.instance.reference().child("reviews");
    DataSnapshot snapshot = await db.once();
    Map<dynamic, dynamic> values = snapshot.value;

    values.forEach((key, value) {
      if (value["movieId"] == widget.movieId) {
        ReviewObject review = new ReviewObject(
            userId: value["userId"],
            movieId: value["movieId"],
            reviewId: key,
            userPic: value["userPic"],
            username: value["username"],
            review: value["review"],
            rating: value["rating"].toDouble(),
            likes: value["likes"],
            dislikes: value["dislikes"],
            language: value["language"]);
        reviewsList.add(review);
      }
    });

    return reviewsList;
  }
}

Widget getBody(snapshot, onGoBack, movieId) {
  if (snapshot.data.length == 0) {
    return Center(
      child: Text(
        language.no_review,
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w600,
          fontSize: height * 0.023,
          fontFamily: 'Quicksand',
        ),
      ),
    );
  } else {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _controller,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              reviewIndex = index;
              reviewsListReversed = new List.from(snapshot.data.reversed);
              return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ReviewWidget(
                    index: index,
                    snapshot: reviewsListReversed,
                    onGoBack: onGoBack,
                    movieId: movieId,
                  ));
            },
          ),
        ),
      ],
    );
  }
}

class ReviewWidget extends StatefulWidget {
  const ReviewWidget({
    Key key,
    @required this.index,
    @required this.snapshot,
    @required this.onGoBack,
    @required this.movieId,
  }) : super(key: key);
  final int index;
  final List<ReviewObject> snapshot;
  final FutureOr onGoBack;
  final int movieId;

  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  Color _likeColor = Colors.grey;
  Color _dislikeColor = Colors.grey;

  int _nLikes;
  int _nDislikes;

  _ReviewWidgetState();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: getReviewData(widget.snapshot, widget.index),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            _likeColor = snapshot.data[0];
            _dislikeColor = snapshot.data[1];
            _nLikes = snapshot.data[2];
            _nDislikes = snapshot.data[3];
            double rating;
            if (widget.snapshot[widget.index].rating != null) {
              rating = widget.snapshot[widget.index].rating.toDouble();
            } else {
              rating = 0.0;
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatarText(
                        review: widget.snapshot[widget.index],
                      ),
                      DeleteReviewButton(
                          uid: widget.snapshot[widget.index].userId,
                          movieId: widget.movieId,
                          onGoBack: widget.onGoBack),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  RatingUnclickable(
                      unratedColor: Colors.grey.withOpacity(0.5),
                      rate: rating,
                      size: 23.0),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  ReadMoreText(
                    widget.snapshot[widget.index].review,
                    trimLines: 8,
                    delimiter: '',
                    colorClickableText: themePrimaryColor,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: language.read_more,
                    trimExpandedText: language.show_less,
                    moreStyle: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold,
                        color: themePrimaryColor),
                    style: TextStyle(
                      fontSize: height * 0.02,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Quicksand',
                    ),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          await getLikeDislike(
                              widget.snapshot[widget.index].reviewId, "like");
                          await likeSetColor(
                                  widget.snapshot[widget.index].reviewId)
                              .then((value) {
                            _likeColor = value;
                            _dislikeColor = Colors.grey;
                          }).then(widget.onGoBack);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => themeSecondaryColor),
                        ),
                        icon: Icon(Icons.thumb_up, color: _likeColor),
                        label: Text(
                          _nLikes.toString(),
                          style: TextStyle(
                              color: _likeColor,
                              fontSize: height * 0.018,
                              fontFamily: 'Quicksand-Medium'),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          await getLikeDislike(
                              widget.snapshot[widget.index].reviewId,
                              "dislike");
                          await dislikeSetColor(
                                  widget.snapshot[widget.index].reviewId)
                              .then((value) {
                            _dislikeColor = value;
                            _likeColor = Colors.grey;
                          }).then(widget.onGoBack);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => themeSecondaryColor),
                        ),
                        icon: Icon(Icons.thumb_down, color: _dislikeColor),
                        label: Text(
                          _nDislikes.toString(),
                          style: TextStyle(
                              color: _dislikeColor,
                              fontSize: height * 0.018,
                              fontFamily: 'Quicksand-Medium'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  Divider(
                    color: Colors.grey[700],
                  ),
                ],
              ),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.amber,
            ));
          }
        });
  }

  void getLikeDislike(reviewId, like_dislike) async {
    var likeDb = FirebaseDatabase.instance.reference().child("likes");
    DataSnapshot likeSnapshot = await likeDb.once();
    Map<dynamic, dynamic> likeValues = likeSnapshot.value;

    bool isInDb = false;
    var reviewRef = FirebaseDatabase.instance
        .reference()
        .child("reviews/" + widget.snapshot[widget.index].reviewId);
    var reviewDb = FirebaseDatabase.instance.reference().child("reviews");
    DataSnapshot reviewSnap = await reviewDb.once();
    Map<dynamic, dynamic> reviewVal = reviewSnap.value;
    int numLikes;
    int numDislikes;
    await reviewVal.forEach((key, value) {
      if (key == reviewId) {
        numLikes = value["likes"];
        numDislikes = value["dislikes"];
      }
    });
    final notificationDao = NotificationDao();

    if (likeValues != null) {
      likeValues.forEach((key, value) {
        var likeRef =
            FirebaseDatabase.instance.reference().child("likes/" + key);

        if (value["reviewId"] == reviewId && value["userId"] == userId) {
          isInDb = true;
          if (isInDb) {
            if (like_dislike == "like") {
              likeRef.update({
                "liked": true,
                "disliked": false,
              });

              final notificationData = NotificationData(
                  widget.snapshot[widget.index].userId,
                  userlogged,
                  widget.movieId,
                  "like");
              if (value["disliked"]) {
                reviewRef.update({
                  "likes": numLikes + 1,
                  "dislikes": numDislikes - 1,
                });
                _nLikes = numLikes + 1;
                _nDislikes = numDislikes - 1;
                likeRef.update({
                  "liked": true,
                  "disliked": false,
                });
                updateNotificationInDB(widget.snapshot[widget.index].userId,
                    widget.movieId, "like");
              } else if (value["liked"]) {
                likeRef.update({
                  "liked": false,
                });
                reviewRef.update({
                  "likes": numLikes - 1,
                });
                _nLikes = numLikes - 1;
                removeNotificationFromDB(
                    widget.snapshot[widget.index].userId, widget.movieId);
              } else {
                reviewRef.update({
                  "likes": numLikes + 1,
                });
                _nLikes = numLikes + 1;
                likeRef.update({
                  "liked": true,
                });
                notificationDao.saveNotification(notificationData);
              }
            } else if (like_dislike == "dislike") {
              final notificationData = NotificationData(
                  widget.snapshot[widget.index].userId,
                  userlogged,
                  widget.movieId,
                  "dislike");

              likeRef.update({
                "liked": false,
                "disliked": true,
              });

              if (value["liked"]) {
                reviewRef.update({
                  "likes": numLikes - 1,
                  "dislikes": numDislikes + 1,
                });
                _nLikes = numLikes - 1;
                _nDislikes = numDislikes + 1;
                likeRef.update({
                  "liked": false,
                  "disliked": true,
                });
                updateNotificationInDB(widget.snapshot[widget.index].userId,
                    widget.movieId, "dislike");
              } else if (value["disliked"]) {
                likeRef.update({
                  "disliked": false,
                });
                reviewRef.update({
                  "dislikes": numDislikes - 1,
                });
                _nDislikes = numDislikes - 1;
                removeNotificationFromDB(
                    widget.snapshot[widget.index].userId, widget.movieId);
              } else {
                reviewRef.update({
                  "dislikes": numDislikes + 1,
                });
                _nDislikes = numDislikes + 1;
                likeRef.update({
                  "disliked": true,
                });
                notificationDao.saveNotification(notificationData);
              }
            }
          }
        }
      });
    }

    if (!isInDb) {
      final likeDao = LikeDao();

      if (like_dislike == "like") {
        final likeData = LikeData(userId, reviewId, true, false);
        await likeDao.saveLike(likeData);
        reviewRef.update({
          "likes": numLikes + 1,
        });
        _nLikes = numLikes + 1;

        final notificationData = NotificationData(
            widget.snapshot[widget.index].userId,
            userlogged,
            widget.movieId,
            "like");
        notificationDao.saveNotification(notificationData);
      } else if (like_dislike == "dislike") {
        final likeData = LikeData(userId, reviewId, false, true);
        await likeDao.saveLike(likeData);
        reviewRef.update({
          "dislikes": numDislikes + 1,
        });
        _nDislikes = numDislikes + 1;
        final notificationData = NotificationData(
            widget.snapshot[widget.index].userId,
            userlogged,
            widget.movieId,
            "like");
        notificationDao.saveNotification(notificationData);
      }
    }
  }

  Future<Color> likeSetColor(reviewId) async {
    Color likeColor = Colors.grey;
    var db = FirebaseDatabase.instance.reference().child("likes");
    DataSnapshot snapshot = await db.once();
    Map<dynamic, dynamic> values = snapshot.value;

    if (values != null) {
      values.forEach((key, value) {
        if (value["reviewId"] == reviewId && value["userId"] == userId) {
          if (value["liked"]) {
            likeColor = themePrimaryColor;
          } else if (value["liked"] == null) {
            likeColor = Colors.grey;
          } else {
            likeColor = Colors.grey;
          }
        }
      });
    }

    return likeColor;
  }

  Future<int> getNumLikes(reviewId) async {
    int nLikes;
    var db = FirebaseDatabase.instance.reference().child("reviews");
    DataSnapshot snapshot = await db.once();
    Map<dynamic, dynamic> values = snapshot.value;
    if (values != null) {
      values.forEach((key, value) {
        if (key == reviewId) {
          nLikes = value["likes"];
        }
      });
    }
    return nLikes;
  }

  Future<int> getNumDislikes(reviewId) async {
    int nDislikes;
    var db = FirebaseDatabase.instance.reference().child("reviews");
    DataSnapshot snapshot = await db.once();
    Map<dynamic, dynamic> values = snapshot.value;
    if (values != null) {
      values.forEach((key, value) {
        if (key == reviewId) {
          nDislikes = value["dislikes"];
        }
      });
    }
    return nDislikes;
  }

  Future<Color> dislikeSetColor(reviewId) async {
    Color dislikeColor = Colors.grey;
    var db = FirebaseDatabase.instance.reference().child("likes");
    DataSnapshot snapshot = await db.once();
    Map<dynamic, dynamic> values = snapshot.value;

    if (values != null) {
      values.forEach((key, value) {
        if (value["reviewId"] == reviewId && value["userId"] == userId) {
          if (value["disliked"]) {
            dislikeColor = themePrimaryColor;
          } else if (value["disliked"] == null) {
            dislikeColor = Colors.grey;
          } else {
            dislikeColor = Colors.grey;
          }
        }
      });
    }

    return dislikeColor;
  }

  Future<List> getReviewData(snapshot, index) async {
    Color lColor, dlColor;
    int nL, nD;
    lColor = await likeSetColor(snapshot[index].reviewId);
    dlColor = await dislikeSetColor(snapshot[index].reviewId);
    nL = await getNumLikes(snapshot[index].reviewId);
    nD = await getNumDislikes(snapshot[index].reviewId);
    return [lColor, dlColor, nL, nD];
  }
}

void removeNotificationFromDB(String userIdReceiver, int movieId) async {
  var notificationDb =
      FirebaseDatabase.instance.reference().child("notifications");
  DataSnapshot notificationSnapshot = await notificationDb.once();
  Map<dynamic, dynamic> notificationValues = notificationSnapshot.value;
  if (notificationValues != null) {
    notificationValues.forEach((key, value) {
      if (value["userIdReceiver"] == userIdReceiver &&
          value["movieId"] == movieId) {
        FirebaseDatabase.instance
            .reference()
            .child('notifications')
            .child(key)
            .remove();
      }
    });
  }
}

void updateNotificationInDB(
    String userIdReceiver, int movieId, String reaction) async {
  var notificationDb =
      FirebaseDatabase.instance.reference().child("notifications");
  DataSnapshot notificationSnapshot = await notificationDb.once();
  Map<dynamic, dynamic> notificationValues = notificationSnapshot.value;
  if (notificationValues != null) {
    notificationValues.forEach((key, value) {
      if (value["userIdReceiver"] == userIdReceiver &&
          value["movieId"] == movieId) {
        FirebaseDatabase.instance
            .reference()
            .child("notifications/" + key)
            .update({
          "reaction": reaction,
        });
      }
    });
  }
}

Future<bool> reviewInDb(movieId) async {
  var db = FirebaseDatabase.instance.reference().child("reviews");
  DataSnapshot snapshot = await db.once();
  Map<dynamic, dynamic> values = snapshot.value;

  bool reviewInDb = false;

  if (values != null) {
    values.forEach((key, value) {
      if (value["userId"] == userId && value["movieId"] == movieId) {
        reviewInDb = true;
      }
    });
  }
  return reviewInDb;
}

class DeleteReviewButton extends StatefulWidget {
  const DeleteReviewButton({
    Key key,
    @required this.uid,
    @required this.onGoBack, this.movieId,
  }) : super(key: key);
  final String uid;
  final int movieId;
  final FutureOr onGoBack;

  @override
  State<DeleteReviewButton> createState() => _DeleteReviewButtonState();
}

class _DeleteReviewButtonState extends State<DeleteReviewButton> {
  @override
  Widget build(BuildContext context) {
    if (userId == widget.uid) {
      isReviewed = true;
      return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  content: StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            language.remove_review,
                            style: TextStyle(
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Quicksand'),
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
                                    minimumSize:
                                        Size(width * 0.1, height * 0.005),
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
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
                                    minimumSize:
                                        Size(width * 0.1, height * 0.005),
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      isReviewed = false;
                                    });
                                    FirebaseDatabase.instance
                                        .reference()
                                        .child('reviews')
                                        .orderByChild('userId')
                                        .equalTo(userId)
                                        .once()
                                        .then((DataSnapshot snapshot) {
                                      Map<dynamic, dynamic> children =
                                          snapshot.value;
                                      children.forEach((key, valueReview) {
                                        if(valueReview["movieId"] == widget.movieId && valueReview["userId"] == widget.uid ){
                                          FirebaseDatabase.instance
                                            .reference()
                                            .child('reviews')
                                            .child(key)
                                            .remove();
                                          FirebaseDatabase.instance
                                            .reference()
                                            .child('likes')
                                            .orderByChild('reviewId')
                                            .equalTo(key)
                                            .once()
                                            .then((DataSnapshot snapshot) {
                                            Map<dynamic, dynamic> children =
                                              snapshot.value;
                                            children.forEach((key, valueReview) {
                                              FirebaseDatabase.instance
                                                .reference()
                                                .child('likes')
                                                .child(key)
                                                .remove();
                                          });
                                        });
                                        }
                                        
                                      });
                                    }).then((value) {
                                      Navigator.of(context).pop();
                                      Fluttertoast.showToast(
                                        msg: language.remove_review_toast,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 4,
                                        backgroundColor: themeToastColor,
                                        textColor: Colors.black,
                                        fontSize: 16.0,
                                      );
                                    });
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
                          ),
                        ],
                      );
                    },
                  ),
                );
              }).then(widget.onGoBack);
        },
        icon: Icon(
          Icons.close,
          color: Colors.grey[700],
        ),
      );
    } else {
      isReviewed = false;
      return Container();
    }
  }
}

class CircleAvatarText extends StatelessWidget {
  const CircleAvatarText({
    Key key,
    @required this.review,
  }) : super(key: key);

  final ReviewObject review;

  @override
  Widget build(BuildContext context) {
    String url = review.userPic;
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(url),
          radius: width * 0.06,
        ),
        SizedBox(
          width: width * 0.02,
        ),
        Text(
          review.username,
          style: TextStyle(
            fontSize: height * 0.02,
            fontWeight: FontWeight.w800,
            fontFamily: 'Quicksand',
          ),
        ),
      ],
    );
  }
}
