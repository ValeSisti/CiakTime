import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:ciak_time/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: kPrimaryColor,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: kPrimaryColor,
      onPrimary: kPrimaryColor,
      primaryVariant: kPrimaryColor,
      secondary: kPrimaryColor,
      brightness: Brightness.light,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: Colors.white70, width: 0.5),
          borderRadius: BorderRadius.circular(4.0)),
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF212121),
    appBarTheme: AppBarTheme(
      color: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.amber,
      onPrimary: Colors.black,
      primaryVariant: Colors.black,
      secondary: Colors.black,
      background: const Color(0xFF212121),
      brightness: Brightness.dark,
    ),
    cardTheme: CardTheme(
        color: Colors.black26,
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.black38, width: 0.2),
            borderRadius: BorderRadius.circular(4.0))),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    dialogBackgroundColor: const Color(0xFF212121),
    backgroundColor: const Color(0xFF212121),
  );
}

class AppConfig extends StatefulWidget {
  final Widget child;
  const AppConfig({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  State<AppConfig> createState() => _AppConfigState();
}

class _AppConfigState extends State<AppConfig> {
  StreamSubscription<ConnectivityResult> subscription;

  @override
  initState() {
    super.initState();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      globalResult = result;
      if (result != ConnectivityResult.mobile &&
          result != ConnectivityResult.wifi) {
        showDialog(
            context: context,
            builder: (_) {
              return ConnectionDialog(context: context);
            });
      }
    });
  }

  @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    FlutterError.onError = (FlutterErrorDetails details) async {
      if (globalResult != ConnectivityResult.mobile &&
          globalResult != ConnectivityResult.wifi &&
          !showingDialog) {
        showDialog(
            context: context,
            builder: (_) {
              showingDialog = true;
              return ConnectionDialog(context: context);
            }).then((_) {
          showingDialog = false;
        });
      }
    };
    locale = Localizations.localeOf(context);
    if (locale.toString() == "en") {
      api_language = "en-US";
    } else if (locale.toString() == "it") {
      api_language = "it-IT";
    }
    language = AppLocalizations.of(context);
    var brightness = MediaQuery.of(context).platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    Size size = MediaQuery.of(context).size;
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    

    if (isPortrait) {
      height = size.height;
      width = size.width;
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      height = size.width;
      width = size.height;
    }

    if (Platform.isAndroid) {
      isAndroid = true;
    } else if (Platform.isIOS) {
      isAndroid = false;
    }

    if (isDarkMode) {
      themePrimaryColor = Colors.amber;
      themeSecondaryColor = Colors.white;
      themeSecondaryTextColor = Colors.white70;
      themeDialogPrimaryColor = Colors.white70;
      themeDividerColor = Colors.white70;
      themeIconColor = Colors.black87;
      shadowColor = Colors.black;
      themeToastColor = Colors.white;

      loginRegisterColor = Colors.black87;

      searchBarColor = Colors.black;
      hintColor = Colors.white;
      tabColor = Colors.black26;
      unselectedLabelColor = Colors.white;

      ratingColor = Colors.white54;

      colorRate = Colors.white;
      colorMostAdded = Colors.white;
      colorMostRecent = Colors.white;
      colorDrama = Colors.white;
      colorComedy = Colors.white;
      colorAction = Colors.white;
      colorCrime = Colors.white;
      colorFantasy = Colors.white;
      colorThriller = Colors.white;
      colorFamily = Colors.white;
      colorAnime = Colors.white;
      colorHorror = Colors.white;
      filterTitleColor = Colors.white;
      filterSelectedColor = Colors.amber;
      borderFilterColor = Colors.amber;
      resetColor = Colors.white;
      resetBackgroundColor = Colors.transparent;
      resetBorderColor = Colors.amber;
      showResultColor = Colors.black;
    } else {
      themePrimaryColor = kPrimaryColor;
      themeSecondaryColor = kPrimaryLightColor;
      themeSecondaryTextColor = Colors.black54;
      themeDialogPrimaryColor = Colors.black;
      themeDividerColor = Colors.grey[700];
      themeIconColor = Colors.white;
      shadowColor = Colors.transparent;
      themeToastColor = kPrimaryLightColor;

      loginRegisterColor = Colors.white;

      searchBarColor = kPrimaryColor;
      hintColor = navBarColor;
      tabColor = tabBarColor;
      unselectedLabelColor = kPrimaryLightColor;

      ratingColor = Colors.grey.withOpacity(0.5);

      colorRate = Colors.black;
      colorMostAdded = Colors.black;
      colorMostRecent = Colors.black;
      colorDrama = Colors.black;
      colorComedy = Colors.black;
      colorAction = Colors.black;
      colorCrime = Colors.black;
      colorFantasy = Colors.black;
      colorThriller = Colors.black;
      colorFamily = Colors.black;
      colorAnime = Colors.black;
      colorHorror = Colors.black;
      filterTitleColor = kPrimaryColor;
      filterSelectedColor = kPrimaryColor;
      borderFilterColor = kPrimaryColor;
      resetColor = Colors.amber;
      resetBackgroundColor = Colors.white;
      resetBorderColor = Colors.amber;
      showResultColor = Colors.white;
    }

    return widget.child;
  }
}

class ConnectionDialog extends StatelessWidget {
  const ConnectionDialog({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          language.connectivity_error_message,
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
                  minimumSize: Size(width * 0.1, height * 0.005),
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
                  minimumSize: Size(width * 0.1, height * 0.005),
                  padding: EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  AppSettings.openWIFISettings().then((value) {
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  language.go_to_settings,
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
    ));
  }
}
