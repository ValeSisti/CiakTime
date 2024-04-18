import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ciak_time/Screens/Login/login_screen.dart';
import 'package:ciak_time/Screens/User/profile_pic.dart';
import 'package:ciak_time/components/rounded_button.dart';
import 'package:ciak_time/components/section_divider.dart';
import 'package:ciak_time/components/text_field_container.dart';
import 'package:ciak_time/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IsMatchValidator extends TextFieldValidator {
  String errorText;
  // pass the error text to the super constructor
  IsMatchValidator({
    @required this.errorText,
  }) : super('');

  // return false if you want the validator to return error
  // message when the value is empty.
  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String value) {
    // return true if the value is valid according the your condition
    return value == newPassword;
  }
}

class PassMatchValidator extends TextFieldValidator {
  bool isMatch = false;
  String pass;
  String errorText;
  // pass the error text to the super constructor
  PassMatchValidator({
    @required this.errorText,
    @required this.pass,
  }) : super('');

  // return false if you want the validator to return error
  // message when the value is empty.
  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String value) {
    // return true if the value is valid according the your condition

    return isMatch = pass == value;
  }
}

class UserSettings extends StatefulWidget {
  const UserSettings({
    Key key,
  }) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  bool isOldHidden = true;
  bool isNewHidden = true;
  bool isNewConfirmHidden = true;
  final usernameController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newPasswordConfirmController = TextEditingController();

  var newPasswordValidator = MultiValidator([
    RequiredValidator(errorText: language.required_password),
    MinLengthValidator(8, errorText: language.length_pass),
    PatternValidator(r'(?=.*?[#?!@$%^&*-_])', errorText: language.special_pass),
  ]);

  FutureOr onGoBack(dynamic value) {
    setState(() {
      isOldHidden = true;
      isNewHidden = true;
      isNewConfirmHidden = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usernameValidator = MultiValidator([
      RequiredValidator(errorText: language.valid_username),
    ]);

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
          language.settings,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              Center(child: ProfilePic()),
              SizedBox(
                height: height * 0.04,
              ),
              SectionDiv(
                  label: language.change_settings,
                  fontSize: 0.05,
                  colorDiv: themeDividerColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userlogged,
                    style: TextStyle(
                        fontSize: height * 0.025,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand'),
                  ),
                  SizedBox(width: width * 0.02),
                  IconButton(
                    onPressed: () {
                      setState(
                        () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextFieldContainer(
                                          child: TextFormField(
                                            onChanged: (value) {
                                              setState(() {
                                                usermodified = value;
                                              });
                                            },
                                            controller: usernameController,
                                            validator: usernameValidator,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            style: TextStyle(
                                                color: textFieldColor,
                                                fontWeight: FontWeight.w600),
                                            cursorColor: themePrimaryColor,
                                            decoration: InputDecoration(
                                              errorMaxLines: 2,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: -10),
                                              icon: Icon(
                                                Icons.person,
                                                size: width * 0.05,
                                                color: themePrimaryColor,
                                              ),
                                              hintText: language.new_username,
                                              hintStyle: TextStyle(
                                                  fontSize: height * 0.018,
                                                  fontFamily: 'Quicksand',
                                                  color: hintTextFieldColor),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    .unfocus();
                                                usernameController.clear();
                                                usermodified = '';
                                                buttonModifyUserColor =
                                                    Colors.grey[300];
                                                buttonModifyUserTextColor =
                                                    Colors.grey;
                                                isOldHidden = true;
                                                isNewHidden = true;
                                                isNewConfirmHidden = true;
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                language.back,
                                                style: TextStyle(
                                                  color:
                                                      themeDialogPrimaryColor,
                                                  fontSize: height * 0.02,
                                                  fontFamily: 'Quicksand',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                if (usermodified != "") {
                                                  var db = FirebaseDatabase
                                                      .instance
                                                      .reference()
                                                      .child("users");
                                                  DataSnapshot snapshot =
                                                      await db.once();
                                                  Map<dynamic, dynamic> values =
                                                      snapshot.value;
                                                  if (values != null) {
                                                    values
                                                        .forEach((key, value) {
                                                      if (value["uid"] ==
                                                          userId) {
                                                        FirebaseDatabase
                                                            .instance
                                                            .reference()
                                                            .child(
                                                                "users/" + key)
                                                            .update({
                                                          "username":
                                                              usermodified
                                                        });
                                                      }
                                                    });
                                                  }
                                                  setState(() {
                                                    userlogged = usermodified;
                                                  });
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      .unfocus();
                                                  usernameController.clear();
                                                  Navigator.pop(context);
                                                } else {
                                                  showOkAlertDialog(
                                                      context: context,
                                                      title: language
                                                          .new_username_alert);
                                                }
                                              },
                                              child: Text(
                                                language.save,
                                                style: TextStyle(
                                                  color: setButtonColor(),
                                                  fontSize: height * 0.02,
                                                  fontFamily: 'Quicksand',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ).then(onGoBack);
                        },
                      );
                    },
                    icon: Icon(Icons.create),
                    iconSize: height * 0.035,
                    color: themePrimaryColor,
                  ),
                ],
              ),
              ModifyPassWidget(context),
              getSizedBox(),
              RoundedButton(
                text: language.logout,
                radius: 29,
                color: themePrimaryColor,
                textColor: loginRegisterColor,
                press: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return new AlertDialog(
                        content: StatefulBuilder(
                          builder: (context, setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  language.logout_alert,
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
                                          final FirebaseAuth _auth =
                                              FirebaseAuth.instance;

                                          if (googleConnected) {
                                            await GoogleSignIn().disconnect();
                                            await _auth.signOut();
                                          }
                                          if (facebookConnected) {
                                            await FacebookAuth.instance
                                                .logOut();
                                            await _auth.signOut();
                                          }
                                          if (emailAndPasswordConnected) {
                                            await _auth.signOut();
                                          }

                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs?.clear();

                                          googleConnected = false;
                                          facebookConnected = false;
                                          emailAndPasswordConnected = false;
                                          loginEmail = '';
                                          loginPassword = '';
                                          isHidden = true;
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          LoginScreen()));
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
                    },
                  );
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  primary: Colors.transparent,
                  minimumSize: Size(width * 0.1, height * 0.005),
                  padding: EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return new AlertDialog(
                        content: StatefulBuilder(
                          builder: (context, setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  language.delete_alert,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: height * 0.02,
                                    fontFamily: 'Quicksand',
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.025,
                                ),
                                Text(
                                  language.delete_info,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: height * 0.018,
                                    fontFamily: 'Quicksand',
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                ListTile(
                                  leading: Text(
                                    '•',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: height * 0.025,
                                      fontFamily: 'Quicksand',
                                    ),
                                  ),
                                  minLeadingWidth: 2,
                                  title: Text(
                                    language.delete_info2,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: height * 0.018,
                                      fontFamily: 'Quicksand',
                                    ),
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
                                          final FirebaseAuth _auth =
                                              FirebaseAuth.instance;
                                          try {
                                            await _auth.currentUser
                                                .delete()
                                                .then((value) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          LoginScreen()));
                                              clearDB();
                                            });
                                          } on FirebaseAuthException catch (e) {
                                            if (e.code ==
                                                'requires-recent-login') {
                                              if (emailAndPasswordConnected) {
                                                String newEmail;
                                                String newPassword;
                                                String pippo;
                                                String paperino;

                                                final newEmailController =
                                                    TextEditingController();
                                                final newPasswordController =
                                                    TextEditingController();

                                                await showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                        return AlertDialog(
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              TextFieldContainer(
                                                                child:
                                                                    TextFormField(
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      newEmail =
                                                                          value;
                                                                    });
                                                                  },
                                                                  controller:
                                                                      newEmailController,
                                                                  style: TextStyle(
                                                                      color:
                                                                          textFieldColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                  cursorColor:
                                                                      themePrimaryColor,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    errorMaxLines:
                                                                        2,
                                                                    contentPadding:
                                                                        EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                -10),
                                                                    icon: Icon(
                                                                      Icons
                                                                          .person,
                                                                      size: width *
                                                                          0.05,
                                                                      color:
                                                                          themePrimaryColor,
                                                                    ),
                                                                    hintText:
                                                                        language
                                                                            .new_email,
                                                                    hintStyle: TextStyle(
                                                                        fontSize:
                                                                            height *
                                                                                0.018,
                                                                        fontFamily:
                                                                            'Quicksand',
                                                                        color:
                                                                            hintTextFieldColor),
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                  ),
                                                                ),
                                                              ),
                                                              TextFieldContainer(
                                                                child:
                                                                    TextFormField(
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      newPassword =
                                                                          value;
                                                                    });
                                                                  },
                                                                  controller:
                                                                      newPasswordController,
                                                                  style: TextStyle(
                                                                      color:
                                                                          textFieldColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                  cursorColor:
                                                                      themePrimaryColor,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    errorMaxLines:
                                                                        2,
                                                                    contentPadding:
                                                                        EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                -10),
                                                                    icon: Icon(
                                                                      Icons
                                                                          .person,
                                                                      size: width *
                                                                          0.05,
                                                                      color:
                                                                          themePrimaryColor,
                                                                    ),
                                                                    hintText:
                                                                        language
                                                                            .new_password,
                                                                    hintStyle: TextStyle(
                                                                        fontSize:
                                                                            height *
                                                                                0.018,
                                                                        fontFamily:
                                                                            'Quicksand',
                                                                        color:
                                                                            hintTextFieldColor),
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      if (newEmail !=
                                                                              "" &&
                                                                          newPassword !=
                                                                              "") {
                                                                        pippo =
                                                                            newEmail;
                                                                        paperino =
                                                                            newPassword;
                                                                        FocusManager
                                                                            .instance
                                                                            .primaryFocus
                                                                            .unfocus();
                                                                        newEmailController
                                                                            .clear();
                                                                        newPasswordController
                                                                            .clear();
                                                                        Navigator.pop(
                                                                            context);
                                                                      } else {
                                                                        showOkAlertDialog(
                                                                            context:
                                                                                context,
                                                                            title:
                                                                                language.valid_credentials_required);
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      language
                                                                          .save,
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            themePrimaryColor,
                                                                        fontSize:
                                                                            height *
                                                                                0.02,
                                                                        fontFamily:
                                                                            'Quicksand',
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ).then((value) async {
                                                  AuthCredential credential =
                                                      EmailAuthProvider
                                                          .credential(
                                                              email: pippo,
                                                              password:
                                                                  paperino);
                                                  try {
                                                    await firebaseUser
                                                        .reauthenticateWithCredential(
                                                            credential)
                                                        .then((value) async {
                                                      await _auth
                                                          .signOut()
                                                          .then((value) =>
                                                              firebaseUser
                                                                  .delete()
                                                                  .then(
                                                                      (value) {
                                                                clearDB();
                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (BuildContext context) =>
                                                                                LoginScreen()));
                                                              })); //TODO
                                                    });
                                                  } on FirebaseAuthException catch (e) {
                                                    showOkAlertDialog(
                                                        context: context,
                                                        title:
                                                            "Credenziali errate",
                                                        message:
                                                            "Credenziali inserite non valide.");
                                                  }
                                                });
                                              }
                                              if (googleConnected) {
                                                showOkAlertDialog(
                                                        context: context,
                                                        title:
                                                            "Credenziali scadute",
                                                        message:
                                                            "Effettuare nuovamente il login.")
                                                    .then((value) async {
                                                  OAuthCredential
                                                      googleAuthCredential;
                                                  if (kIsWeb) {
                                                    var googleProvider =
                                                        GoogleAuthProvider();
                                                    await _auth.signInWithPopup(
                                                        googleProvider);
                                                  } else {
                                                    final GoogleSignInAccount
                                                        googleUser =
                                                        await GoogleSignIn()
                                                            .signIn();
                                                    final GoogleSignInAuthentication
                                                        googleAuth =
                                                        await googleUser
                                                            .authentication;
                                                    googleAuthCredential =
                                                        GoogleAuthProvider
                                                            .credential(
                                                      accessToken: googleAuth
                                                          .accessToken,
                                                      idToken:
                                                          googleAuth.idToken,
                                                    );
                                                    await _auth
                                                        .signInWithCredential(
                                                            googleAuthCredential);
                                                  }
                                                  try {
                                                    await firebaseUser
                                                        .reauthenticateWithCredential(
                                                            googleAuthCredential)
                                                        .then((value) async {
                                                      await GoogleSignIn()
                                                          .disconnect()
                                                          .then((value) =>
                                                              firebaseUser
                                                                  .delete()
                                                                  .then(
                                                                      (value) {
                                                                clearDB();
                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (BuildContext context) =>
                                                                                LoginScreen()));
                                                              })); //TODO
                                                    });
                                                  } on FirebaseAuthException catch (e) {
                                                    showOkAlertDialog(
                                                        context: context,
                                                        title: language
                                                            .wrong_credential_title,
                                                        message: language
                                                            .wrong_credential_message);
                                                  }
                                                });
                                              }
                                              if (facebookConnected) {
                                                showOkAlertDialog(
                                                        context: context,
                                                        title: language
                                                            .expired_credential_title,
                                                        message: language
                                                            .expired_credential_message)
                                                    .then((value) async {
                                                  OAuthCredential
                                                      facebookAuthCredential;
                                                  final LoginResult
                                                      loginResult =
                                                      await FacebookAuth
                                                          .instance
                                                          .login();

                                                  // Create a credential from the access token

                                                  facebookAuthCredential =
                                                      FacebookAuthProvider
                                                          .credential(
                                                              loginResult
                                                                  .accessToken
                                                                  .token);

                                                  // Once signed in, return the UserCredential
                                                  await FirebaseAuth.instance
                                                      .signInWithCredential(
                                                          facebookAuthCredential);

                                                  try {
                                                    await firebaseUser
                                                        .reauthenticateWithCredential(
                                                            facebookAuthCredential)
                                                        .then((value) async {
                                                      await FacebookAuth
                                                          .instance
                                                          .logOut()
                                                          .then((value) =>
                                                              firebaseUser
                                                                  .delete()
                                                                  .then(
                                                                      (value) {
                                                                clearDB();
                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (BuildContext context) =>
                                                                                LoginScreen()));
                                                              }));
                                                    });
                                                  } on FirebaseAuthException catch (e) {
                                                    showOkAlertDialog(
                                                        context: context,
                                                        title: language
                                                            .expired_credential_title,
                                                        message: language
                                                            .expired_credential_message);
                                                  }
                                                });
                                              }
                                            }
                                          }

                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs?.clear();

                                          googleConnected = false;
                                          facebookConnected = false;
                                          emailAndPasswordConnected = false;

                                          loginEmail = '';
                                          loginPassword = '';
                                          isHidden = true;
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
                    },
                  );
                },
                child: Text(
                  language.delete_account,
                  style: TextStyle(
                    color: themePrimaryColor,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clearDB() {
    var dbUsers = FirebaseDatabase.instance.reference().child("users");
    var dbReviews = FirebaseDatabase.instance.reference().child("reviews");
    var dbLikes = FirebaseDatabase.instance.reference().child("likes");
    var dbNotifications =
        FirebaseDatabase.instance.reference().child("notifications");

    dbUsers.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          if (values["uid"] == userId) {
            dbUsers.child(key).remove();
          }
        });
      }
    });
    List<String> reviewKeys = [];
    dbReviews.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          if (values["userId"] == userId) {
            reviewKeys.add(key);
            dbReviews.child(key).remove();
          }
        });
      }
    });

    dbLikes.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) async {
          if (values["userId"] == userId) {
            int numLikes;
            int numDislikes;
            await dbReviews
                .child(values["reviewId"])
                .once()
                .then((DataSnapshot snapshot) {
              if (snapshot.value != null) {
                numLikes = snapshot.value["likes"];
                numDislikes = snapshot.value["dislikes"];
                values["liked"]
                    ? dbReviews
                        .child(values["reviewId"])
                        .update({"likes": numLikes - 1})
                    : dbReviews
                        .child(values["reviewId"])
                        .update({"dislikes": numDislikes - 1});
              }
            });
            dbLikes.child(key).remove();
          } else if (reviewKeys.contains(values["reviewId"])) {
            dbLikes.child(key).remove();
          }
        });
      }
    });

    dbNotifications.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          if (values["userIdReceiver"] == userId) {
            dbUsers.child(key).remove();
          }
        });
      }
    });
  }

  Widget getSizedBox() {
    if (emailAndPasswordConnected) {
      return SizedBox(height: height * 0.16);
    } else {
      return SizedBox(height: height * 0.22);
    }
  }

  Widget ModifyPassWidget(context) {
    if (emailAndPasswordConnected) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            language.change_password,
            style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.w600,
                fontFamily: 'Quicksand'),
          ),
          SizedBox(width: width * 0.02),
          IconButton(
            onPressed: () {
              setState(
                () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFieldContainer2(
                                  child: Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      FutureBuilder(
                                          future: getUserPassInDB(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String>
                                                  passSnapshotto) {
                                            if (passSnapshotto.hasData) {
                                              password = passSnapshotto.data;
                                              return TextFormField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    oldPassword = value;
                                                  });
                                                },
                                                controller:
                                                    oldPasswordController,
                                                validator: PassMatchValidator(
                                                    errorText:
                                                        language.incorrect_pass,
                                                    pass: passSnapshotto.data),
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                obscureText: isOldHidden,
                                                cursorColor: themePrimaryColor,
                                                style: TextStyle(
                                                    color: textFieldColor),
                                                decoration: InputDecoration(
                                                  errorMaxLines: 2,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: -10),
                                                  icon: Icon(
                                                    Icons.lock,
                                                    color: themePrimaryColor,
                                                    size: width * 0.05,
                                                  ),
                                                  hintText: language
                                                      .insert_current_password,
                                                  hintStyle: TextStyle(
                                                      fontSize: height * 0.0145,
                                                      fontFamily: 'Quicksand',
                                                      color:
                                                          hintTextFieldColor),
                                                  border: InputBorder.none,
                                                ),
                                              );
                                            } else if (passSnapshotto
                                                .hasError) {
                                              return Text(passSnapshotto.error
                                                  .toString());
                                            }
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Colors.amber,
                                            ));
                                          }),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CupertinoButton(
                                              minSize: double.minPositive,
                                              padding: EdgeInsets.zero,
                                              child: isOldHidden
                                                  ? Icon(
                                                      Icons.visibility_off,
                                                      color: themePrimaryColor,
                                                      size: width * 0.05,
                                                    )
                                                  : Icon(
                                                      Icons.visibility,
                                                      color: themePrimaryColor,
                                                      size: width * 0.05,
                                                    ),
                                              onPressed: () {
                                                setState(() {
                                                  toggleOldPasswordVisibility();
                                                });
                                              }),
                                          CupertinoButton(
                                              minSize: double.minPositive,
                                              padding: EdgeInsets.fromLTRB(
                                                  3.0, 0.0, 0.0, 0.0),
                                              child: Icon(
                                                Icons.info,
                                                color: themePrimaryColor,
                                                size: width * 0.05,
                                              ),
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return new AlertDialog(
                                                          content:
                                                              StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                              return Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .info,
                                                                        color:
                                                                            themePrimaryColor,
                                                                      ),
                                                                      SizedBox(
                                                                        width: width *
                                                                            0.05,
                                                                      ),
                                                                      Container(
                                                                        width: width *
                                                                            0.5,
                                                                        child:
                                                                            Text(
                                                                          language
                                                                              .insert_current_password_info,
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                height * 0.02,
                                                                            fontFamily:
                                                                                'Quicksand',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                TextFieldContainer2(
                                  child: Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      TextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            newPassword = value;
                                          });
                                        },
                                        controller: newPasswordController,
                                        validator: newPasswordValidator,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        obscureText: isNewHidden,
                                        cursorColor: themePrimaryColor,
                                        style: TextStyle(color: textFieldColor),
                                        decoration: InputDecoration(
                                          errorMaxLines: 2,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: -10),
                                          icon: Icon(
                                            Icons.lock,
                                            color: themePrimaryColor,
                                            size: width * 0.05,
                                          ),
                                          hintText:
                                              language.choose_new_password,
                                          hintStyle: TextStyle(
                                              fontSize: height * 0.0145,
                                              fontFamily: 'Quicksand',
                                              color: hintTextFieldColor),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CupertinoButton(
                                              minSize: double.minPositive,
                                              padding: EdgeInsets.zero,
                                              child: isNewHidden
                                                  ? Icon(
                                                      Icons.visibility_off,
                                                      color: themePrimaryColor,
                                                      size: width * 0.05,
                                                    )
                                                  : Icon(
                                                      Icons.visibility,
                                                      color: themePrimaryColor,
                                                      size: width * 0.05,
                                                    ),
                                              onPressed: () {
                                                setState(() {
                                                  toggleNewPasswordVisibility();
                                                });
                                              }),
                                          CupertinoButton(
                                              padding: EdgeInsets.fromLTRB(
                                                  3, 0.0, 0.0, 0.0),
                                              minSize: double.minPositive,
                                              child: Icon(
                                                Icons.info,
                                                color: themePrimaryColor,
                                                size: width * 0.05,
                                              ),
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return new AlertDialog(
                                                          content:
                                                              StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                              return Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .info,
                                                                        color:
                                                                            themePrimaryColor,
                                                                      ),
                                                                      SizedBox(
                                                                        width: width *
                                                                            0.05,
                                                                      ),
                                                                      Container(
                                                                        width: width *
                                                                            0.5,
                                                                        child:
                                                                            Text(
                                                                          language
                                                                              .password_rules,
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                height * 0.02,
                                                                            fontFamily:
                                                                                'Quicksand',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                TextFieldContainer2(
                                  child: Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      TextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            newConfirmPassword = value;
                                          });
                                        },
                                        controller:
                                            newPasswordConfirmController,
                                        validator: IsMatchValidator(
                                            errorText: language.valid_password),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        obscureText: isNewConfirmHidden,
                                        cursorColor: themePrimaryColor,
                                        style: TextStyle(color: textFieldColor),
                                        decoration: InputDecoration(
                                          errorMaxLines: 2,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: -10),
                                          icon: Icon(
                                            Icons.lock,
                                            size: width * 0.05,
                                            color: themePrimaryColor,
                                          ),
                                          hintText:
                                              language.confirm_new_password,
                                          hintStyle: TextStyle(
                                              fontSize: height * 0.0145,
                                              fontFamily: 'Quicksand',
                                              color: hintTextFieldColor),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CupertinoButton(
                                              minSize: double.minPositive,
                                              padding: EdgeInsets.zero,
                                              child: isNewConfirmHidden
                                                  ? Icon(
                                                      Icons.visibility_off,
                                                      color: themePrimaryColor,
                                                      size: width * 0.05,
                                                    )
                                                  : Icon(
                                                      Icons.visibility,
                                                      color: themePrimaryColor,
                                                      size: width * 0.05,
                                                    ),
                                              onPressed: () {
                                                setState(() {
                                                  toggleNewConfirmPasswordVisibility();
                                                });
                                              }),
                                          CupertinoButton(
                                              minSize: double.minPositive,
                                              padding: EdgeInsets.fromLTRB(
                                                  3.0, 0.0, 0.0, 0.0),
                                              child: Icon(
                                                Icons.info,
                                                color: themePrimaryColor,
                                                size: width * 0.05,
                                              ),
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return new AlertDialog(
                                                          content:
                                                              StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                              return Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .info,
                                                                        color:
                                                                            themePrimaryColor,
                                                                      ),
                                                                      SizedBox(
                                                                        width: width *
                                                                            0.05,
                                                                      ),
                                                                      Container(
                                                                        width: width *
                                                                            0.5,
                                                                        child:
                                                                            Text(
                                                                          language
                                                                              .confirm_password_rules,
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                height * 0.02,
                                                                            fontFamily:
                                                                                'Quicksand',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus
                                            .unfocus();
                                        oldPasswordController.clear();
                                        newPasswordController.clear();
                                        newPasswordConfirmController.clear();
                                        oldPassword = '';
                                        newPassword = '';
                                        newConfirmPassword = '';
                                        setButtonPasswordColor();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        language.back,
                                        style: TextStyle(
                                          color: themeDialogPrimaryColor,
                                          fontSize: height * 0.02,
                                          fontFamily: 'Quicksand',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (newPassword != "" &&
                                            oldPassword != "" &&
                                            newConfirmPassword != "" &&
                                            newPassword == newConfirmPassword &&
                                            oldPassword == password) {
                                          var db = FirebaseDatabase.instance
                                              .reference()
                                              .child("users");
                                          DataSnapshot snapshot =
                                              await db.once();
                                          Map<dynamic, dynamic> values =
                                              snapshot.value;
                                          if (values != null) {
                                            values.forEach((key, value) {
                                              if (value["uid"] == userId) {
                                                FirebaseDatabase.instance
                                                    .reference()
                                                    .child("users/" + key)
                                                    .update({
                                                  "password": newPassword
                                                });
                                              }
                                            });
                                          }
                                          firebaseUser
                                              .updatePassword(newPassword);
                                          setState(() {
                                            FocusManager.instance.primaryFocus
                                                .unfocus();

                                            newPasswordController.clear();
                                            oldPasswordController.clear();
                                            newPasswordConfirmController
                                                .clear();
                                          });
                                          Navigator.pop(context);
                                        } else {
                                          showOkAlertDialog(
                                              context: context,
                                              title:
                                                  language.new_password_alert);
                                        }
                                      },
                                      child: Text(
                                        language.save,
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
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ).then(onGoBack);
                },
              );
            },
            icon: Icon(Icons.create),
            iconSize: height * 0.035,
            color: themePrimaryColor,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Future<String> getUserPassInDB() async {
    String string = "";
    var db = FirebaseDatabase.instance.reference().child("users");
    DataSnapshot snapshot = await db.once();
    Map<dynamic, dynamic> values = snapshot.value;

    if (values != null) {
      values.forEach((key, value) {
        if (value["uid"] == userId) {
          string = value["password"];
        }
      });
    }
    return string;
  }

  Color setButtonColor() {
    if (usermodified != '' && userlogged != usermodified) {
      buttonModifyUserColor = themePrimaryColor;
    } else {
      buttonModifyUserColor = Colors.grey[300];
    }
    return buttonModifyUserColor;
  }

  Color setButtonPasswordColor() {
    if (newPassword.isNotEmpty &&
        oldPassword.isNotEmpty &&
        newConfirmPassword.isNotEmpty &&
        newPassword == newConfirmPassword &&
        oldPassword == password &&
        newPassword != oldPassword) {
      buttonPasswordColor = themePrimaryColor;
    } else {
      buttonPasswordColor = Colors.grey[300];
    }
    return buttonPasswordColor;
  }

  Color setButtonTextPasswordColor() {
    if (newPassword.isNotEmpty &&
        oldPassword.isNotEmpty &&
        newConfirmPassword.isNotEmpty &&
        newPassword == newConfirmPassword &&
        oldPassword == password &&
        newPassword != oldPassword) {
      buttonPasswordTextColor = Colors.white;
    } else {
      buttonPasswordTextColor = Colors.grey;
    }

    return buttonPasswordTextColor;
  }

  void toggleOldPasswordVisibility() => setState(() {
        isOldHidden = !isOldHidden;
      });

  void toggleNewPasswordVisibility() => setState(() {
        isNewHidden = !isNewHidden;
      });

  void toggleNewConfirmPasswordVisibility() => setState(() {
        isNewConfirmHidden = !isNewConfirmHidden;
      });
}
