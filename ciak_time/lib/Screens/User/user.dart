import 'dart:async';
import 'package:ciak_time/Screens/User/notification.dart';
import 'package:ciak_time/Services/db_api.dart';
import 'package:ciak_time/components/card_list.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> with TickerProviderStateMixin {
  StreamSubscription<Event> _listener;
  StreamSubscription<Event> _listener_changed;
  bool initialDataLoaded = false;

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  AnimationController _animationController;

  @override
  void initState() {
    var ref = FirebaseDatabase.instance.reference();
    _listener = ref.child('notifications').onChildAdded.listen((event) {
      if (initialDataLoaded) {
        if (event.snapshot.value["userIdReceiver"] == userId) {
          setState(() {
            notification = true;
          });
        }
      }
    });
    _listener_changed =
        ref.child('notifications').onChildChanged.listen((event) {
      if (initialDataLoaded) {
        if (event.snapshot.value["userIdReceiver"] == userId) {
          setState(() {
            notification = true;
          });
        }
      }
    });
    ref.once().then((value) {
      initialDataLoaded = true;
    });

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    super.initState();
  }

  void _runAnimation() async {
    if (notification) {
      for (var i = 0; i < 3; i++) {
        await _animationController.forward();
        await _animationController.reverse();
        if (!notification) {
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _listener.cancel();
    _listener_changed.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          language.user,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings').then(onGoBack);
            },
            child: Row(
              children: [
                Text(
                  language.settings,
                  style: TextStyle(
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<List<Movie>>>(
        future: getListsFromDB(),
        builder: (context, AsyncSnapshot<List<List<Movie>>> snapshot) {
          if (notification) {
            _runAnimation();
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return buildUserPage(snapshot);
          }
        },
      ),
    );
  }

  Widget buildUserPage(AsyncSnapshot<List<List<Movie>>> snapshot) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(children: [
              Column(
                children: [
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(profilePicUrl),
                        backgroundColor: Colors.white,
                        radius: height * 0.08,
                      )
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: -.1)
                      .chain(CurveTween(curve: Curves.elasticIn))
                      .animate(_animationController),
                  child: IconButton(
                    onPressed: () {
                      //TODO far aprire la pagina dove si possono vedere le notifiche
                      setState(() {
                        notification = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return NotificationPage();
                          },
                        ),
                      );
                    },
                    splashRadius: 25,
                    icon: Icon(
                      Icons.notifications_rounded,
                      size: width * 0.08,
                    ),
                    color: themePrimaryColor,
                  ),
                ),
              ),
              Positioned(
                top: 18,
                right: 18,
                child: Icon(
                  Icons.circle,
                  size: width * 0.04,
                  color: notification ? Colors.red : Colors.transparent,
                ),
              ),
            ]),
            SizedBox(
              height: height * 0.02,
            ),
            Text(
              userlogged,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontFamily: 'Quicksand',
                fontSize: height * 0.03,
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
                width: width * 0.97, child: Divider(color: themeDividerColor)),
            SizedBox(
              height: height * 0.01,
            ),
            CardList(
              onGoBack: onGoBack,
              title: language.watchlist,
              number: snapshot.data[0].length,
              list: snapshot.data[0],
            ),
            CardList(
              onGoBack: onGoBack,
              title: language.already_watched,
              number: snapshot.data[1].length,
              list: snapshot.data[1],
            ),
            CardList(
              onGoBack: onGoBack,
              title: language.favourite,
              number: snapshot.data[2].length,
              list: snapshot.data[2],
            ),
          ],
        ),
      ),
    );
  }
}
