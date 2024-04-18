import 'dart:async';
import 'package:ciak_time/Screens/Movie/movie_utils.dart';
import 'package:ciak_time/Screens/Review/review_object.dart';
import 'package:ciak_time/Services/db_api.dart';
import 'package:ciak_time/api_utils.dart';
import 'package:ciak_time/blocs/movie_details_bloc.dart';
import 'package:ciak_time/blocs/movie_images_bloc.dart';
import 'package:ciak_time/components/movie_cast_list.dart';
import 'package:ciak_time/components/movie_directors_list.dart';
import 'package:ciak_time/components/rating.dart';
import 'package:ciak_time/components/watch_providers_list.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie_details_model.dart';
import 'package:ciak_time/models/movie_images_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readmore/readmore.dart';

class MovieUser extends StatefulWidget {
  const MovieUser({
    Key key,
  }) : super(key: key);
  @override
  _MovieUserState createState() => _MovieUserState();
}

class _MovieUserState extends State<MovieUser> {
  ScrollController _scrollController;
  double kExpandedHeight = 250.0;

  MovieDetailsBloc bloc_details;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    bloc_details = MovieDetailsBloc(movieSelectedFromUser.id.toString());
    bloc_details.fetchMovieDetailsResults();
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments
        as ScreenArguments; //TODO non è usato?
    return Scaffold(
        body: CustomScrollView(controller: _scrollController, slivers: <Widget>[
      SliverLayoutBuilder(
        builder: (BuildContext context, constraints) {
          final scrolled = constraints.scrollOffset > kExpandedHeight - 80;

          return SliverAppBar(
            expandedHeight: kExpandedHeight,
            leading: TextButton(
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            leadingWidth: width * 0.25,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  showMenu(
                      context: context,
                      position:
                          new RelativeRect.fromLTRB(60.0, 40.0, 0.0, 100.0),
                      items: [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: width * 0.6,
                                child: TextButton.icon(
                                  onPressed: () async {
                                    await checkDisabledButton(context);
                                  },
                                  icon: SvgPicture.asset(
                                      "assets/icons/list.svg",
                                      height: height * 0.03),
                                  label: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: FutureBuilder(
                                              future: getWatchListTitle(
                                                  movieSelectedFromUser),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      titleSnapshot) {
                                                if (titleSnapshot.hasData) {
                                                  return Text(
                                                    titleSnapshot.data,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color:
                                                            themeDialogPrimaryColor,
                                                        fontSize: height * 0.02,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            'Quicksand'),
                                                  );
                                                } else if (titleSnapshot
                                                    .hasError) {
                                                  return Text(titleSnapshot
                                                      .error
                                                      .toString());
                                                }

                                                return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: Colors.amber,
                                                ));
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(color: themeDividerColor),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: width * 0.6,
                                child: TextButton.icon(
                                  onPressed: () async {
                                    if (alreadyWatchedListTitle ==
                                        language.remove_already_watched) {
                                      await deleteMovieFromDBList(
                                          "alreadyWatched",
                                          userId,
                                          movieSelectedFromUser.id);
                                      buildFlutterToast(language
                                          .remove_already_watched_toast);
                                      Navigator.pop(context);
                                    } else {
                                      int isContainedInWatchList =
                                          await checkMovieInList("watchList",
                                              userId, movieSelectedFromUser.id);
                                      if (isContainedInWatchList == 1) {
                                        await deleteMovieFromDBList("watchList",
                                            userId, movieSelectedFromUser.id);
                                        buildFlutterToast(language
                                            .add_already_watched_toast1);
                                      } else {
                                        await addMovieToDBList(
                                            "alreadyWatched",
                                            userId,
                                            movieSelectedFromUser.id,
                                            movieSelectedFromUser.title,
                                            movieSelectedFromUser.overview,
                                            movieSelectedFromUser.voteAverage,
                                            movieSelectedFromUser.releaseDate,
                                            movieSelectedFromUser.posterPath,
                                            movieSelectedFromUser.voteCount);
                                        buildFlutterToast(language
                                            .add_already_watched_toast2);
                                      }

                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: SvgPicture.asset(
                                      "assets/icons/check.svg",
                                      height: height * 0.03),
                                  label: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: FutureBuilder(
                                              future:
                                                  getAlreadyWatchedListTitle(
                                                      movieSelectedFromUser),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      titleSnapshot) {
                                                if (titleSnapshot.hasData) {
                                                  return Text(
                                                    titleSnapshot.data,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color:
                                                            themeDialogPrimaryColor,
                                                        fontSize: height * 0.02,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily:
                                                            'Quicksand'),
                                                  );
                                                } else if (titleSnapshot
                                                    .hasError) {
                                                  return Text(titleSnapshot
                                                      .error
                                                      .toString());
                                                }

                                                return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: Colors.amber,
                                                ));
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(color: themeDividerColor),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Container(
                            width: width * 0.6,
                            child: TextButton.icon(
                              onPressed: () async {
                                if (favouriteListTitle ==
                                    language.remove_favourite) {
                                  await deleteMovieFromDBList("favourite",
                                      userId, movieSelectedFromUser.id);
                                  buildFlutterToast(
                                      language.remove_favourite_toast);
                                  Navigator.pop(context);
                                } else {
                                  await addMovieToDBList(
                                      "favourite",
                                      userId,
                                      movieSelectedFromUser.id,
                                      movieSelectedFromUser.title,
                                      movieSelectedFromUser.overview,
                                      movieSelectedFromUser.voteAverage,
                                      movieSelectedFromUser.releaseDate,
                                      movieSelectedFromUser.posterPath,
                                      movieSelectedFromUser.voteCount);
                                  buildFlutterToast(
                                      language.add_favourite_toast);
                                  Navigator.pop(context);
                                }
                              },
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: FutureBuilder(
                                          future: getFavouriteListTitle(
                                              movieSelectedFromUser),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String>
                                                  titleSnapshot) {
                                            if (titleSnapshot.hasData) {
                                              return Text(
                                                titleSnapshot.data,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color:
                                                        themeDialogPrimaryColor,
                                                    fontSize: height * 0.02,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Quicksand'),
                                              );
                                            } else if (titleSnapshot.hasError) {
                                              return Text(titleSnapshot.error
                                                  .toString());
                                            }

                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Colors.amber,
                                            ));
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]).then((value) => onGoBack(value));
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              )
            ],
            snap: false,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: scrolled ? true : false,
              titlePadding: EdgeInsets.symmetric(
                  vertical: _verticalTitlePadding,
                  horizontal: _horizontalTitlePadding),
              title: StreamBuilder(
                  stream: bloc_details.movieDetails,
                  builder: (BuildContext context,
                      AsyncSnapshot<MovieDetailsModel> snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.title,
                          overflow: scrolled
                              ? TextOverflow.ellipsis
                              : TextOverflow.visible,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: _titleSize,
                            fontFamily: 'Quicksand-Medium',
                          ));
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.amber,
                    ));
                  }),
              background: Stack(
                children: [
                  MovieCover(),
                  Container(
                    height: 410.0,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                            stops: [
                          0.0,
                          1.0
                        ])),
                  ),
                  Positioned(
                    bottom: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.005),
                            Container(
                              height: height * 0.03,
                              child: Row(
                                children: [
                                  MovieDuration(),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 0.0, 8.0, 0.0),
                                    child: VerticalDivider(
                                        color: Colors.white54,
                                        width: 1.5,
                                        thickness: 1),
                                  ),
                                  MovieGenres(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      //3
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.grey[700],
                      ),
                      SizedBox(width: width * 0.02),
                      MovieReleaseDate(),
                      SizedBox(width: width * 0.08),
                      FutureBuilder(
                          future: Future.wait([
                            isMovieSeenIcon(movieSelectedFromUser),
                            isMovieSeenColor(movieSelectedFromUser)
                          ]),
                          //isMovieSeenIcon(movieSelectedFromHome),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<dynamic>> snapshot) {
                            if (snapshot.hasData) {
                              return Icon(
                                snapshot.data[0],
                                color: snapshot.data[1],
                              );
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }

                            return Center(
                                child: CircularProgressIndicator(
                              color: Colors.amber,
                            ));
                          }),
                      SizedBox(width: width * 0.02),
                      FutureBuilder(
                          future: isMovieSeen(movieSelectedFromUser),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data,
                                style: TextStyle(
                                  fontSize: height * 0.02,
                                  fontFamily: 'Quicksand-Regular',
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }

                            return Center(
                                child: CircularProgressIndicator(
                              color: Colors.amber,
                            ));
                          }),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Divider(color: themeDividerColor),
                  Text(language.overview,
                      style: TextStyle(
                          color: themePrimaryColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Quicksand',
                          fontSize: height * 0.025)),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  FutureBuilder(
                      future: getRating(),
                      builder: (BuildContext context,
                          AsyncSnapshot<double> snapshot) {
                        if (snapshot.hasData) {
                          return RatingUnclickable(
                              unratedColor: Colors.grey.withOpacity(0.5),
                              rate: snapshot.data,
                              size: 21.0);
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }

                        return Center(
                            child: CircularProgressIndicator(
                          color: Colors.amber,
                        ));
                      }),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  MovieOverviewWidget(movieId: movieSelectedFromUser.id),
                  TrailerWidget(movieId: movieSelectedFromUser.id),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Divider(color: themeDividerColor),
                  Text(language.where_view,
                      style: TextStyle(
                          color: themePrimaryColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Quicksand',
                          fontSize: height * 0.025)),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  WatchProvidersList(movieSelected: movieSelectedFromUser),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Divider(color: themeDividerColor),
                  Text(language.cast,
                      style: TextStyle(
                          color: themePrimaryColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Quicksand',
                          fontSize: height * 0.025)),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  MovieCastList(
                      movieSelected: movieSelectedFromUser, fromWhere: "User"),
                  Divider(color: themeDividerColor),
                  Text(language.movie_director,
                      style: TextStyle(
                          color: themePrimaryColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Quicksand',
                          fontSize: height * 0.025)),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  MovieDirectorsList(
                      movieSelected: movieSelectedFromUser, fromWhere: "User"),
                  Divider(color: themeDividerColor),
                  FutureBuilder(
                      future: getMyReview(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Widget> snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data;
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }

                        return Center(
                            child: CircularProgressIndicator(
                          color: Colors.amber,
                        ));
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language.ratings_reviews,
                          style: TextStyle(
                              color: themePrimaryColor,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Quicksand',
                              fontSize: height * 0.025)),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/reviewslist')
                              .then(onGoBack);
                        },
                        label:
                            Icon(Icons.arrow_forward, color: themePrimaryColor),
                        icon: Text(
                          language.view_all,
                          style: TextStyle(
                              color: themePrimaryColor,
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Quicksand'),
                        ),
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => themeSecondaryColor),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: width * 0.1,
                      ),
                      SizedBox(width: width * 0.03),
                      FutureBuilder(
                          future: getRating(),
                          builder: (BuildContext context,
                              AsyncSnapshot<double> snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data.toStringAsPrecision(2),
                                style: TextStyle(
                                  fontSize: width * 0.07,
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            }

                            return Center(
                                child: CircularProgressIndicator(
                              color: Colors.amber,
                            ));
                          }),
                      Text(
                        " / 5",
                        style: TextStyle(
                          color: themeSecondaryTextColor,
                          fontSize: width * 0.05,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder(
                      future: getOtherReview(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Widget> snapshot) {
                        return snapshot.data;
                      }),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Divider(color: themeDividerColor),
                ],
              ),
            );
          },
          childCount: 1,
        ),
      ),
    ]));
  }

  double get _horizontalTitlePadding {
    const kBasePadding = 10.0;
    const kMultiplier = 2;
    const kToolbarHeight = 110.0;

    if (_scrollController.hasClients) {
      if (_scrollController.offset < (kExpandedHeight / 2)) {
        // In case 50%-100% of the expanded height is viewed
        return kBasePadding;
      }

      if (_scrollController.offset > (kExpandedHeight - kToolbarHeight)) {
        // In case 0% of the expanded height is viewed
        return (kExpandedHeight / 2 - kToolbarHeight) * kMultiplier +
            kBasePadding;
      }

      // In case 0%-50% of the expanded height is viewed
      return (_scrollController.offset - (kExpandedHeight / 2)) * kMultiplier +
          kBasePadding;
    }

    return kBasePadding;
  }

  double get _verticalTitlePadding {
    double verticalPadding;
    const kToolbarHeight = 80.0;

    if (_scrollController.hasClients) {
      if (_scrollController.offset < (kExpandedHeight / 2)) {
        // In case 50%-100% of the expanded height is viewed
        verticalPadding = 35.0;
        return verticalPadding;
      }

      if (_scrollController.offset > (kExpandedHeight - kToolbarHeight)) {
        // In case 0% of the expanded height is viewed
        verticalPadding = 18.0;
        return verticalPadding;
      }

      // In case 0%-50% of the expanded height is viewed
      verticalPadding = 18.0;
      return verticalPadding;
    }

    return verticalPadding;
  }

  double get _titleSize {
    double size;
    const kToolbarHeight = 80.0;

    if (_scrollController.hasClients) {
      if (_scrollController.offset < (kExpandedHeight / 2)) {
        // In case 50%-100% of the expanded height is viewed
        size = height * 0.02;
        return size;
      }

      if (_scrollController.offset > (kExpandedHeight - kToolbarHeight)) {
        // In case 0% of the expanded height is viewed
        size = height * 0.018;
        return size;
      }

      // In case 0%-50% of the expanded height is viewed
      size = height * 0.018;
      return size;
    }

    return size;
  }

  Future<double> getRating() async {
    var db = FirebaseDatabase.instance.reference().child("reviews");
    DataSnapshot snapshot = await db.once();
    Map<dynamic, dynamic> values = snapshot.value;

    double rating = 0.0;
    double total = 0.0;
    int count = 0;

    if (values != null) {
      values.forEach((key, value) {
        if (value["movieId"] == movieSelectedFromUser.id) {
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

  Future<Widget> getMyReview() async {
    var db = FirebaseDatabase.instance.reference().child("reviews");
    DataSnapshot snapshot = await db.once();
    Map<dynamic, dynamic> values = snapshot.value;

    bool reviewInDb = false;
    ReviewObject reviewObject;

    if (values != null) {
      values.forEach((key, value) {
        if (value["userId"] == userId &&
            value["movieId"] == movieSelectedFromUser.id) {
          reviewInDb = true;
          reviewObject = new ReviewObject(
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
        }
      });
    }
    if (reviewInDb) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.01,
          ),
          Text(language.your_review,
              style: TextStyle(
                  color: themePrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Quicksand',
                  fontSize: height * 0.025)),
          SizedBox(
            height: height * 0.01,
          ),
          ReviewWidget(
              reviewObject: reviewObject, reviewByMe: true, onGoBack: onGoBack),
          SizedBox(
            height: height * 0.01,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Future<Widget> getOtherReview() async {
    var db = FirebaseDatabase.instance.reference().child("reviews");
    DataSnapshot snapshot = await db.once();
    Map<dynamic, dynamic> values = snapshot.value;

    bool reviewInDb = false;
    ReviewObject reviewObject;
    bool myReview = false;

    double temp = 0.0;
    if (values != null) {
      values.forEach((key, value) {
        if (value["movieId"] == movieSelectedFromUser.id) {
          if (value["rating"].toDouble() >= temp) {
            temp = value["rating"].toDouble();
            reviewInDb = true;
            reviewObject = new ReviewObject(
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
          }
        }
      });
    }

    if (reviewInDb) {
      if (reviewObject.userId == userId) {
        myReview = true;
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.03,
          ),
          ReviewWidget(
            reviewObject: reviewObject,
            reviewByMe: myReview,
            onGoBack: onGoBack,
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({
    Key key,
    @required this.reviewObject,
    @required this.reviewByMe,
    @required this.onGoBack,
  }) : super(key: key);

  final ReviewObject reviewObject;

  final bool reviewByMe;
  final FutureOr onGoBack;

  @override
  Widget build(BuildContext context) {
    if (reviewByMe) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(reviewObject.userPic),
                    radius: width * 0.04,
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Text(
                    reviewObject.username,
                    style: TextStyle(
                      fontSize: height * 0.02,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Quicksand',
                    ),
                  ),
                ],
              ),
              DeleteReview(
                onGoBack: onGoBack,
              )
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          RatingUnclickable(
              unratedColor: ratingColor, rate: reviewObject.rating, size: 20.0),
          SizedBox(
            height: height * 0.01,
          ),
          ReadMoreText(
            reviewObject.review,
            trimLines: 3,
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
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(reviewObject.userPic),
                radius: width * 0.04,
              ),
              SizedBox(
                width: width * 0.02,
              ),
              Text(
                reviewObject.username,
                style: TextStyle(
                  fontSize: height * 0.02,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Quicksand',
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          RatingUnclickable(
              unratedColor: ratingColor, rate: reviewObject.rating, size: 20.0),
          SizedBox(
            height: height * 0.01,
          ),
          ReadMoreText(
            reviewObject.review,
            trimLines: 3,
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
        ],
      );
    }
  }
}

class DeleteReview extends StatelessWidget {
  const DeleteReview({
    Key key,
    @required this.onGoBack,
  }) : super(key: key);

  final FutureOr onGoBack;

  @override
  Widget build(BuildContext context) {
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
            }).then(onGoBack);
      },
      icon: Icon(
        Icons.close,
        color: Colors.grey[700],
      ),
    );
  }
}

class MovieCover extends StatefulWidget {
  const MovieCover({
    Key key,
  }) : super(key: key);

  @override
  State<MovieCover> createState() => _MovieCoverState();
}

class _MovieCoverState extends State<MovieCover> {
  MovieImagesBloc bloc;
  @override
  void initState() {
    bloc = MovieImagesBloc(movieSelectedFromUser.id.toString());
    bloc.fetchMovieImagesResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.moviesImages,
      builder: (context, AsyncSnapshot<MovieImagesModel> snapshot) {
        if (snapshot.hasData) {
          return buildCover(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
            child: CircularProgressIndicator(
          color: Colors.amber,
        ));
      },
    );
  }

  Widget buildCover(AsyncSnapshot<MovieImagesModel> snapshot) {
    String imagePath;
    if (snapshot.data.backdrops.length != 0) {
      imagePath =
          'https://image.tmdb.org/t/p/w1280${snapshot.data.backdrops[0].filePath}';
    } else if (snapshot.data.posters.length != 0) {
      imagePath =
          'https://image.tmdb.org/t/p/w780${snapshot.data.posters[0].filePath}';
    } else {
      imagePath = "https://cdn.hipwallpaper.com/i/59/45/2QvigJ.jpg";
    }
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            imagePath,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

buildFlutterToast(list) {
  Fluttertoast.showToast(
    msg: movieSelectedFromUser.title + list,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 3,
    backgroundColor: themeToastColor,
    textColor: Colors.black,
    fontSize: 16.0,
  );
}

checkDisabledButton(context) async {
  int isContained = await checkMovieInList(
      "alreadyWatched", userId, movieSelectedFromUser.id);
  if (isContained == 1) {
    Fluttertoast.showToast(
      msg: language.add_watchlist_toast1,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: themeToastColor,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  } else {
    if (watchListTitle == language.remove_watchlist) {
      await deleteMovieFromDBList(
          "watchList", userId, movieSelectedFromUser.id);

      buildFlutterToast(language.remove_watchlist_toast);
      Navigator.pop(context);
    } else {
      await addMovieToDBList(
          "watchList",
          userId,
          movieSelectedFromUser.id,
          movieSelectedFromUser.title,
          movieSelectedFromUser.overview,
          movieSelectedFromUser.voteAverage,
          movieSelectedFromUser.releaseDate,
          movieSelectedFromUser.posterPath,
          movieSelectedFromUser.voteCount);

      buildFlutterToast(language.add_watchlist_toast2);
      Navigator.pop(context);
    }
  }
}

class MovieDuration extends StatefulWidget {
  const MovieDuration({
    Key key,
  }) : super(key: key);

  @override
  State<MovieDuration> createState() => _MovieDurationState();
}

class _MovieDurationState extends State<MovieDuration> {
  MovieDetailsBloc bloc;
  @override
  void initState() {
    bloc = MovieDetailsBloc(movieSelectedFromUser.id.toString());
    bloc.fetchMovieDetailsResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.movieDetails,
      builder: (context, AsyncSnapshot<MovieDetailsModel> snapshot) {
        if (snapshot.hasData) {
          return buildDetails(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
            child: CircularProgressIndicator(
          color: Colors.amber,
        ));
      },
    );
  }

  Widget buildDetails(AsyncSnapshot<MovieDetailsModel> snapshot) {
    return Text(
      durationToString(snapshot.data.runtime),
      style: TextStyle(
        color: Colors.white,
        fontSize: height * 0.02,
        fontFamily: 'Quicksand-Regular',
      ),
    );
  }
}

class MovieReleaseDate extends StatefulWidget {
  const MovieReleaseDate({
    Key key,
  }) : super(key: key);

  @override
  State<MovieReleaseDate> createState() => _MovieReleaseDateState();
}

class _MovieReleaseDateState extends State<MovieReleaseDate> {
  MovieDetailsBloc bloc;
  @override
  void initState() {
    bloc = MovieDetailsBloc(movieSelectedFromUser.id.toString());
    bloc.fetchMovieDetailsResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.movieDetails,
      builder: (context, AsyncSnapshot<MovieDetailsModel> snapshot) {
        if (snapshot.hasData) {
          return buildDetails(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
            child: CircularProgressIndicator(
          color: Colors.amber,
        ));
      },
    );
  }

  Widget buildDetails(AsyncSnapshot<MovieDetailsModel> snapshot) {
    return GetReleaseDate(snapshot.data.releaseDate);
  }
}

class MovieGenres extends StatefulWidget {
  const MovieGenres({
    Key key,
  }) : super(key: key);

  @override
  State<MovieGenres> createState() => _MovieGenresState();
}

class _MovieGenresState extends State<MovieGenres> {
  MovieDetailsBloc bloc;
  @override
  void initState() {
    bloc = MovieDetailsBloc(movieSelectedFromUser.id.toString());
    bloc.fetchMovieDetailsResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.movieDetails,
      builder: (context, AsyncSnapshot<MovieDetailsModel> snapshot) {
        if (snapshot.hasData) {
          return buildDetails(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
            child: CircularProgressIndicator(
          color: Colors.amber,
        ));
      },
    );
  }

  Widget buildDetails(AsyncSnapshot<MovieDetailsModel> snapshot) {
    return GetGenresNames(snapshot.data.genres);
  }
}
