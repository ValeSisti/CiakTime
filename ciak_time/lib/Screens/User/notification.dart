import 'dart:async';

import 'package:ciak_time/Screens/User/notification_object.dart';
import 'package:ciak_time/blocs/movie_details_bloc.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie_details_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

ScrollController _controller = ScrollController(keepScrollOffset: true);
Function stfBuildSetState;
Widget _newNotificationFloatingButton = Container();
Widget newNotificationBtn = StatefulBuilder(
  builder: (BuildContext context, setState) {
    stfBuildSetState = setState;
    return _newNotificationFloatingButton;
  },
);

class _NotificationPageState extends State<NotificationPage> {
  bool initialDataLoaded = false;
  StreamSubscription<Event> _listenerOnAdded;
  StreamSubscription<Event> _listenerOnChanged;

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    var ref = FirebaseDatabase.instance.reference();

    _listenerOnAdded = ref.child('notifications').onChildAdded.listen((event) {
      if (initialDataLoaded) {
        if (event.snapshot.value["userIdReceiver"] == userId) {
          stfBuildSetState(() {
            _newNotificationFloatingButton = Positioned(
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
                              Text(language.new_notification_button,
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
                            _newNotificationFloatingButton = Container();
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
        return newNotificationBtn;
      }
    });
    _listenerOnChanged =
        ref.child('notifications').onChildChanged.listen((event) {
      if (initialDataLoaded) {
        if (event.snapshot.value["userIdReceiver"] == userId) {
          stfBuildSetState(() {
            _newNotificationFloatingButton = Positioned(
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
                              Text(language.new_notification_button,
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
                            _newNotificationFloatingButton = Container();
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
        return newNotificationBtn;
      }
    });

    ref.once().then((value) {
      initialDataLoaded = true;
    });
  }

  @override
  void dispose() {
    _newNotificationFloatingButton = Container();
    _listenerOnAdded.cancel();
    _listenerOnChanged.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: TextButton(
            onPressed: () {
              notification = false;
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          leadingWidth: 40,
          title: Text(
            language.notifications,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              FutureBuilder<List<NotificationObject>>(
                future: getNotificationsList(),
                builder: (context,
                    AsyncSnapshot<List<NotificationObject>> snapshot) {
                  if (snapshot.hasData) {
                    return getNotifications(snapshot);
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      language.no_notifications,
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
              newNotificationBtn,
            ],
          ),
        ));
  }
}

Widget getNotifications(snapshot) {
  if (snapshot.data.length == 0) {
    return Center(
      child: Text(
        language.no_notifications,
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
              notificationIndex = index;
              notificationListReversed = new List.from(snapshot.data.reversed);
              return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: NotificationWidget(
                      movieId: notificationListReversed[index].movieId,
                      username: notificationListReversed[index].username,
                      reaction: notificationListReversed[index].reaction));
            },
          ),
        ),
      ],
    );
  }
}

Future<List<NotificationObject>> getNotificationsList() async {
  List<NotificationObject> notificationList = [];
  var db = FirebaseDatabase.instance.reference().child("notifications");
  DataSnapshot snapshot = await db.once();
  Map<dynamic, dynamic> values = snapshot.value;

  values.forEach((key, value) {
    if (value["userIdReceiver"] == userId) {
      NotificationObject notification = new NotificationObject(
        username: value["usernameSender"],
        movieId: value["movieId"],
        reaction: value["reaction"],
      );
      notificationList.add(notification);
    }
  });

  return notificationList;
}

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({
    Key key,
    @required this.movieId,
    @required this.username,
    @required this.reaction,
  }) : super(key: key);

  final int movieId;
  final String username;
  final String reaction;

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  _NotificationWidgetState();

  MovieDetailsBloc bloc;

  @override
  void initState() {
    bloc = MovieDetailsBloc(widget.movieId.toString());
    bloc.fetchMovieDetailsResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.movieDetails,
      builder: (context, AsyncSnapshot<MovieDetailsModel> snapshot) {
        if (snapshot.hasData) {
          return buildNotificationWidget(snapshot.data.title);
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

  Widget buildNotificationWidget(String title) {
    String reactionText;
    if (widget.reaction == "like") {
      reactionText = language.like;
    } else {
      reactionText = language.dislike;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.015),
          Text(
            widget.username +
                language.notification_text_1 +
                reactionText +
                language.notification_text_2 +
                title,
            style: TextStyle(
                fontSize: height * 0.022,
                fontWeight: FontWeight.w600,
                fontFamily: 'Quicksand'),
          ),
          SizedBox(height: height * 0.01),
          Divider(
            color: Colors.grey[700],
          ),
        ],
      ),
    );
  }
}
