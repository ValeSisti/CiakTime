import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ciak_time/Screens/Login/login_screen.dart';
import 'package:ciak_time/Screens/navbar.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/utils/app_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance().then((value) async {
    var status = value.getBool('isLoggedIn') ?? false;
    userId = value.getString('userId') ?? '';
    userlogged = value.getString('username') ?? '';
    profilePicUrl = value.getString('userPic') ?? '';
    runApp(MyApp(status: status));
  });
}

class MyApp extends StatefulWidget {
  final status;

  const MyApp({Key key, @required this.status}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  bool _initialized = false;
  bool _error = false;
  bool animationCompleted = false;
  AnimationController _controller;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      globalResult = await (Connectivity().checkConnectivity());

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: (4)),
      vsync: this,
    );
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    if (isDarkMode) {
      themePrimaryColor = Colors.amber;
      scaffoldBackgroundColor = Color(0xFF212121);
    } else {
      themePrimaryColor = kPrimaryColor;
      scaffoldBackgroundColor = Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Scaffold(
        body: Text("errore"),
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!(_initialized && animationCompleted)) {
      print("starting animation");
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en', ''), Locale('it', '')],
        home: Scaffold(
            backgroundColor: scaffoldBackgroundColor,
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/images/splash_movie.json',
                    controller: _controller,
                    height: 200,
                    frameRate: FrameRate.max,
                    animate: true,
                    onLoaded: (composition) {
                      _controller
                        ..duration = composition.duration
                        ..forward().whenComplete(() => setState(() {
                              animationCompleted = true;
                            }));
                    },
                  ),
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pattaya',
                      color: Colors.amber,
                    ),
                    child: AnimatedTextKit(animatedTexts: [
                      TyperAnimatedText('CiakTime', speed: Duration(milliseconds: 100)),
                    ],
                    isRepeatingAnimation: false,),
                  ),
                ],
              ),
            )),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CiakTime',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en', ''), Locale('it', '')],
      home: widget.status == true
          ? AppConfig(child: HomePage())
          : AppConfig(child: LoginScreen()),
    );
  }
}
