import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ciak_time/Screens/Login/components/background.dart';
import 'package:ciak_time/Screens/Login/reset_screen.dart';
import 'package:ciak_time/Screens/Signup/signup_screen.dart';
import 'package:ciak_time/Screens/navbar.dart';
import 'package:ciak_time/components/rounded_input_field.dart';
import 'package:ciak_time/components/rounded_password_field.dart';
import 'package:ciak_time/components/section_divider.dart';
import 'package:ciak_time/components/social_icon.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/database/userDao.dart';
import 'package:ciak_time/database/userData.dart';
import 'package:ciak_time/utils/app_theme.dart';
import 'package:ciak_time/utils/device_orientation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FutureOr onGoBack(dynamic value) {
    FocusManager.instance.primaryFocus.unfocus();

    loginUsernameController.clear();

    loginPasswordController.clear();
  }

  @override
  void initState() {
    super.initState();
    portraitModeOnly();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: height * 0.08,
              ),
              Text(
                "CiakTime",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.08,
                  fontFamily: 'Pattaya',
                  color: themePrimaryColor,
                  shadows: [
                    Shadow(offset: Offset(-3, 3), color: shadowColor),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.08,
              ),
              Container(
                width: width * 0.75,
                child: Text(
                  language.signin,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: height * 0.03,
                      fontFamily: 'Quicksand-Medium',
                      color: themePrimaryColor),
                ),
              ),
              RoundedInputField(
                hintText: language.email,
                onChanged: (value) {
                  setState(() {
                    loginEmail = value;
                  });
                },
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  setState(() {
                    loginPassword = value;
                  });
                },
              ),
              Container(
                alignment: Alignment.centerRight,
                width: width * 0.75,
                height: height * 0.025,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    primary: Colors.transparent,
                    minimumSize: Size(width * 0.1, height * 0.005),
                    padding: EdgeInsets.all(0.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ResetScreen();
                        },
                      ),
                    ).then((value) {
                      setState(() {
                        FocusManager.instance.primaryFocus.unfocus();
                        emailResetPasswordController.clear();
                        loginUsernameController.clear();
                        loginPasswordController.clear();
                        emailConfirmColor = Colors.grey[300];
                        emailTextConfirmColor = Colors.grey;
                      });
                    });
                  },
                  child: Text(
                    language.forgot_password,
                    style: TextStyle(
                      color: themePrimaryColor,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    color: changeLoginColor(),
                    onPressed: () async {
                      if ((globalResult == ConnectivityResult.mobile ||
                          globalResult == ConnectivityResult.wifi)) {
                        await emailAndPasswordSignIn().then((value) {
                          if (emailAndPasswordConnected) {
                            setState(() {
                              FocusManager.instance.primaryFocus.unfocus();
                              loginUsernameController.clear();
                              loginPasswordController.clear();                              
                            });
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return HomePage();
                                },
                              ),
                            ).then((value) {
                            setState(() {
                              FocusManager.instance.primaryFocus.unfocus();
                              loginUsernameController.clear();
                              loginPasswordController.clear();
                            });
                          });
                          } else {
                            showOkAlertDialog(
                                context: context,
                                title: language.login_error,
                                message: language.login_alert);
                          }
                        });
                      } else {
                        if (globalResult != ConnectivityResult.mobile &&
                            globalResult != ConnectivityResult.wifi) {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return ConnectionDialog(context: context);
                              });
                        }
                      }
                    },
                    child: Text(
                      language.login,
                      style: TextStyle(
                        color: changeLoginTextColor(),
                        fontSize: width * 0.05,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              SectionDiv(
                  label: language.sign_with_platform,
                  fontSize: 0.038,
                  colorDiv: themeDividerColor),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocialIcon(
                    socialFlag: false,
                    iconSrc: "assets/icons/google.svg",
                    press: () async {
                      await googleSignIn().then((value) {
                        if (googleConnected) {
                          setState(() {
                              FocusManager.instance.primaryFocus.unfocus();
                              loginUsernameController.clear();
                              loginPasswordController.clear();
                            });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HomePage();
                              },
                            ),
                          ).then((value) {
                            setState(() {
                              FocusManager.instance.primaryFocus.unfocus();
                              loginUsernameController.clear();
                              loginPasswordController.clear();
                            });
                          });
                        }
                      });
                    },
                  ),
                  SocialIcon(
                    socialFlag: false,
                    iconSrc: "assets/icons/facebook.svg",
                    press: () async {
                      await facebookSignIn().then((value) {
                        if (facebookConnected) {
                          setState(() {
                              FocusManager.instance.primaryFocus.unfocus();
                              loginUsernameController.clear();
                              loginPasswordController.clear();
                            });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HomePage();
                              },
                            ),
                          ).then((value) {
                            setState(() {
                              FocusManager.instance.primaryFocus.unfocus();
                              loginUsernameController.clear();
                              loginPasswordController.clear();
                            });
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    language.no_account,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      primary: Colors.transparent,
                      minimumSize: Size(width * 0.1, height * 0.005),
                      padding: EdgeInsets.all(0.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SignUpScreen();
                          },
                        ),
                      ).then((value) {
                        onGoBack(value);
                        setState(() {
                          FocusManager.instance.primaryFocus.unfocus();
                          loginUsernameController.clear();
                          loginPasswordController.clear();
                          loginEmail = '';
                          loginPassword = '';
                        });
                      });
                    },
                    child: Text(language.signup,
                        style: TextStyle(
                          color: themePrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quicksand',
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color changeLoginColor() {
    setState(() {
      if (loginEmail != '' && loginPassword != '') {
        loginColor = themePrimaryColor;
      } else {
        loginColor = Colors.grey[300];
      }
    });

    return loginColor;
  }

  Color changeLoginTextColor() {
    setState(() {
      if (loginEmail != '' && loginPassword != '') {
        loginTextColor = loginRegisterColor;
      } else {
        loginTextColor = Colors.grey;
      }
    });

    return loginTextColor;
  }
}

Future googleSignIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    UserCredential userCredential;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (kIsWeb) {
      var googleProvider = GoogleAuthProvider();
      userCredential = await _auth.signInWithPopup(googleProvider);
    } else {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);
    }
    googleConnected = true;

    firebaseUser = userCredential.user;
    email = "";
    password = "";
    userId = firebaseUser.uid;
    userlogged = firebaseUser.displayName;
    username = firebaseUser.displayName;

    profilePicUrl = firebaseUser.photoURL.replaceAll("s96", "s400");
    bool alreadyInDb = false;

    var db = FirebaseDatabase.instance.reference().child("users");
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          if (values["uid"] == userId) {
            alreadyInDb = true;
            profilePicUrl = values["imgUrl"];
          }
        });
      }

      if (alreadyInDb == false) {
        final userDao = UserDao();
        final userData =
            UserData(email, username, profilePicUrl, userId, password);
        userDao.saveUser(userData);
      }

      prefs?.setBool('isLoggedIn', true);
      prefs?.setString('userId', userId);
      prefs?.setString('userPic', profilePicUrl);
      prefs?.setString('username', userlogged);
    });
  } catch (e) {
    googleConnected = false;
    print(e);
  }
}

Future facebookSignIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    UserCredential userCredential;

    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken.token);

    // Once signed in, return the UserCredential
    userCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    facebookConnected = true;
    //FirebaseAuth.instance.signInWithPopup(facebookAuthCredential);

    firebaseUser = userCredential.user;
    email = "";
    password = "";
    userId = firebaseUser.uid;
    userlogged = firebaseUser.displayName;
    username = firebaseUser.displayName;
    profilePicUrl = firebaseUser.photoURL + "?height=500";

    bool alreadyInDb = false;

    var db = FirebaseDatabase.instance.reference().child("users");
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      if (values != null) {
        values.forEach((key, values) {
          if (values["uid"] == userId) {
            alreadyInDb = true;
          }
        });
      }

      if (!alreadyInDb) {
        final userDao = UserDao();
        final userData =
            UserData(email, username, profilePicUrl, userId, password);
        userDao.saveUser(userData);
      }

      prefs?.setBool("isLoggedIn", true);
      prefs?.setString("userId", userId);
      prefs?.setString("userPic", profilePicUrl);
      prefs?.setString("username", userlogged);
    });
  } catch (e) {
    facebookConnected = false;
    print(e);
  }
}

Future emailAndPasswordSignIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    firebaseUser = (await _auth.signInWithEmailAndPassword(
      email: loginEmail,
      password: loginPassword,
    ))
        .user;
    emailAndPasswordConnected = true;
    userId = firebaseUser.uid;

    var db = FirebaseDatabase.instance.reference().child("users");
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (values["uid"] == userId) {
          userlogged = values["username"];
          profilePicUrl = values["imgUrl"];
        }
      });

      prefs?.setBool('isLoggedIn', true);
      prefs?.setString('userId', userId);
      prefs?.setString('userPic', profilePicUrl);
      prefs?.setString('username', userlogged);
      prefs?.setString('password', loginPassword);
      prefs?.setString('email', loginEmail);
      prefs?.setBool('emailLogged', emailAndPasswordConnected);
    });
  } catch (e) {
    emailAndPasswordConnected = false;
    prefs?.setBool('emailLogged', emailAndPasswordConnected);
    print(e);
  }
}
