import 'package:ciak_time/Screens/Homescreen/homescreen.dart';
import 'package:ciak_time/Screens/Movie/movie_home.dart';
import 'package:ciak_time/Screens/Movie/movie_search.dart';
import 'package:ciak_time/Screens/Movie/movie_user.dart';
import 'package:ciak_time/Screens/Person/filmography_grid_view.dart';
import 'package:ciak_time/Screens/Person/person_home.dart';
import 'package:ciak_time/Screens/Person/person_user.dart';
import 'package:ciak_time/Screens/Review/review.dart';
import 'package:ciak_time/Screens/Review/reviews_page.dart';
import 'package:ciak_time/Screens/Search/search.dart';
import 'package:ciak_time/Screens/User/all_movies_aw_list.dart';
import 'package:ciak_time/Screens/User/all_movies_f_list.dart';
import 'package:ciak_time/Screens/User/all_movies_w_list.dart';
import 'package:ciak_time/Screens/User/user.dart';
import 'package:ciak_time/Screens/User/user_settings.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/utils/utils.dart';
import 'package:flutter/material.dart';
import 'Person/person_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Destination {
  Destination(
    this.index,
    this.icon,
    this.destinationName,
  );
  final int index;
  final IconData icon;
  final String destinationName;
}

List<Destination> allDestinations = <Destination>[
  Destination(0, Icons.home, "Home"),
  Destination(1, Icons.search, "Search"),
  Destination(2, Icons.person, "User"),
];

class ViewNavigatorObserver extends NavigatorObserver {
  ViewNavigatorObserver(this.onNavigation);

  final VoidCallback onNavigation;

  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    onNavigation();
  }

  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    onNavigation();
  }
}

class DestinationView extends StatefulWidget {
  const DestinationView(
      {Key key,
      this.destination,
      this.onNavigation,
      this.navigatorKey,
      @required this.callback})
      : super(key: key);

  final Destination destination;
  final VoidCallback onNavigation;
  final Key navigatorKey;
  final Function callback;

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      observers: <NavigatorObserver>[
        ViewNavigatorObserver(widget.onNavigation),
      ],
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            if (widget.destination.destinationName == "User") {
              switch (settings.name) {
                case '/':
                  return User();
                case '/settings':
                  return UserSettings();
                case '/watchlist':
                  return AllMoviesInWList();
                case '/alreadywatchedlist':
                  return AllMoviesInAWList();
                case '/favouritelist':
                  return AllMoviesInFList();
                case '/movie':
                  return MovieUser();
                case '/filmography':
                  return FilmographyGridView(
                    personName: personSelectedFromUser.name,
                    fromWhere: "User",
                    personId: personSelectedFromUser.id,
                  );

                case '/person':
                  return PersonUser();
                case '/reviewslist':
                  return ReviewsPage(
                    title: movieSelectedFromUser.title,
                    movieId: movieSelectedFromUser.id,
                  );
                case '/insertreviewfrommovie':
                  return InsertReview(
                    title: movieSelectedFromUser.title,
                    movieId: movieSelectedFromUser.id,
                  );
                case '/insertreviewfromreviews':
                  return InsertReview(
                    title: language.reviews,
                    movieId: movieSelectedFromUser.id,
                  );
              }
            } else if (widget.destination.destinationName == "Home") {
              switch (settings.name) {
                case '/':
                  return Home(callback: widget.callback);
                case '/movie':
                  return MovieHome();
                case '/person':
                  return PersonHome();
                case '/filmography':
                  return FilmographyGridView(
                    personName: personSelectedFromHome.name,
                    fromWhere: "Home",
                    personId: personSelectedFromHome.id,
                  );

                case '/reviewslist':
                  return ReviewsPage(
                    title: movieSelectedFromHome.title,
                    movieId: movieSelectedFromHome.id,
                  );
                case '/insertreviewfrommovie':
                  return InsertReview(
                    title: movieSelectedFromHome.title,
                    movieId: movieSelectedFromHome.id,
                  );
                case '/insertreviewfromreviews':
                  return InsertReview(
                    title: language.reviews,
                    movieId: movieSelectedFromHome.id,
                  );
              }
            } else if (widget.destination.destinationName == "Search") {
              switch (settings.name) {
                case '/':
                  return Search();
                case '/movie':
                  return MovieSearch();
                case '/person':
                  return PersonSearch();
                case '/filmography':
                  return FilmographyGridView(
                      personName: personSelectedFromSearch.name,
                      fromWhere: "Search",
                      personId: personSelectedFromSearch.id);

                case '/reviewslist':
                  return ReviewsPage(
                    title: movieSelectedFromSearch.title,
                    movieId: movieSelectedFromSearch.id,
                  );
                case '/insertreviewfrommovie':
                  return InsertReview(
                    title: movieSelectedFromSearch.title,
                    movieId: movieSelectedFromSearch.id,
                  );
                case '/insertreviewfromreviews':
                  return InsertReview(
                    title: language.reviews,
                    movieId: movieSelectedFromSearch.id,
                  );
              }
            }
          },
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  void callback(bool value) {
    setState(() {
      showBottomNavbar = value;
    });
  }

  List<GlobalKey> _destinationKeys;
  List<GlobalKey<NavigatorState>> _navigatorKeys;
  List<AnimationController> _faders;
  AnimationController _hide;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _faders =
        allDestinations.map<AnimationController>((Destination destination) {
      return AnimationController(
          vsync: this, duration: Duration(milliseconds: 200));
    }).toList();
    _faders[_currentIndex].value = 1.0;
    _destinationKeys = List<GlobalKey>.generate(
        allDestinations.length, (int index) => GlobalKey()).toList();
    _navigatorKeys = List<GlobalKey<NavigatorState>>.generate(
        allDestinations.length, (int index) => GlobalKey()).toList();
    _hide = AnimationController(vsync: this, duration: kThemeAnimationDuration);
  }

  @override
  void dispose() {
    for (AnimationController controller in _faders) controller.dispose();
    _hide.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) { 
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    isDarkMode = brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        final NavigatorState navigator =
            _navigatorKeys[_currentIndex].currentState;
        if (navigator.canPop()) {
          navigator.pop();
        }

        return false;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: allDestinations.map((Destination destination) {
              final Widget view = FadeTransition(
                opacity: _faders[destination.index]
                    .drive(CurveTween(curve: Curves.fastOutSlowIn)),
                child: KeyedSubtree(
                  key: _destinationKeys[destination.index],
                  child: DestinationView(
                    callback: callback,
                    destination: destination,
                    navigatorKey: _navigatorKeys[destination.index],
                    onNavigation: () {
                      _hide.forward();
                    },
                  ),
                ),
              );
              if (destination.index == _currentIndex) {
                _faders[destination.index].forward();
                return view;
              } else {
                _faders[destination.index].reverse();
                if (_faders[destination.index].isAnimating) {
                  return IgnorePointer(child: view);
                }
                return Offstage(child: view);
              }
            }).toList(),
          ),
          bottomNavigationBar:
              (showBottomNavbar) ? bottomNavbar(context) : null,
        ),
      ),
    );
  }

  Widget bottomNavbar(context) {
    language = AppLocalizations.of(context);
    if (isDarkMode) {
      backGroundNavbar = Colors.black;
      selectedItem = Colors.amber;
      unselectedItemNavbar = Colors.grey[400];
    } else {
      backGroundNavbar = kPrimaryColor;
      selectedItem = Colors.white;
      unselectedItemNavbar = navBarColor;
    }

    return ClipRect(
      child: SizeTransition(
          sizeFactor: _hide,
          axisAlignment: -1.0,
          child: NavbarWidget(
            child: BottomNavigationBar(
              backgroundColor: backGroundNavbar,
              selectedItemColor: selectedItem,
              unselectedItemColor: unselectedItemNavbar,
              currentIndex: _currentIndex,
              selectedFontSize: sizeNavbarSelectedFont(),
              unselectedFontSize: sizeNavbarUnselectedFont(),
              selectedIconTheme: IconThemeData(size: sizeNavbarSelectedIcons()),
              unselectedIconTheme:
                  IconThemeData(size: sizeNavbarUnselectedIcons()),
              onTap: (int index) {
                setState(() {
                  if (_currentIndex != index) {
                    _currentIndex = index;
                  } else {
                    _navigatorKeys[index]
                        .currentState
                        .popUntil((route) => route.isFirst);
                  }
                });
              },
              items: allDestinations.map((Destination destination) {
                return BottomNavigationBarItem(
                    icon: Icon(destination.icon),
                    label: getDestinationName(destination.destinationName));
              }).toList(),
            ),
          )),
    );
  }

  String getDestinationName(destinationName) {
    if (destinationName == "Home") {
      return language.home;
    }
    if (destinationName == "User") {
      return language.user;
    }
    if (destinationName == "Search") {
      return language.search;
    }
  }
}
