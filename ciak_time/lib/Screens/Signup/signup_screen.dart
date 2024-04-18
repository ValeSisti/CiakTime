import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:app_settings/app_settings.dart';
import 'package:ciak_time/Screens/Signup/components/background.dart';
import 'package:ciak_time/components/password_field.dart';
import 'package:ciak_time/components/password_field_confirm.dart';
import 'package:ciak_time/components/text_field_container.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/database/userDao.dart';
import 'package:ciak_time/database/userData.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class UnMatchValidator extends TextFieldValidator {
  String errorText;
  List<String> list;
  UnMatchValidator({@required this.errorText, @required this.list}) : super('');

  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String value) {
    String string = "";
    bool trovata = false;
    for (var i = 0; i < list.length; i++) {
      if (value == list[i]) {
        string = value;
        trovata = true;
      }
    }
    return !trovata;
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final userDao = UserDao();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

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
                  language.signup,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: height * 0.03,
                      fontFamily: 'Quicksand-Medium',
                      color: themePrimaryColor),
                ),
              ),
              FutureBuilder(
                  future: getEmailInDB(),
                  builder:
                      (context, AsyncSnapshot<List<String>> emailSnapshotto) {
                    if (emailSnapshotto.hasData) {
                      emails = emailSnapshotto.data;
                      final emailValidator = MultiValidator([
                        RequiredValidator(errorText: language.valid_email),
                        UnMatchValidator(
                            errorText: language.email_in_use,
                            list: emailSnapshotto.data),
                        EmailValidator(errorText: language.valid_email)
                      ]);
                      return TextFieldContainer(
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          validator: emailValidator,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: TextStyle(
                              color: textFieldColor,
                              fontWeight: FontWeight.w600),
                          cursorColor: themePrimaryColor,
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            icon: Icon(
                              Icons.email,
                              color: themePrimaryColor,
                            ),
                            hintText: language.email,
                            hintStyle: TextStyle(
                              fontSize: height * 0.02,
                              fontFamily: 'Quicksand',
                              color: hintTextFieldColor,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      );
                    } else if (emailSnapshotto.hasError) {
                      return Text(emailSnapshotto.error.toString());
                    }
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.amber,
                    ));
                  }),
              FutureBuilder(
                  future: getUsernamesInDB(),
                  builder:
                      (context, AsyncSnapshot<List<String>> stringSnapshotto) {
                    if (stringSnapshotto.hasData) {
                      users = stringSnapshotto.data;
                      final usernameValidator = MultiValidator([
                        RequiredValidator(errorText: language.valid_username),
                        UnMatchValidator(
                            errorText: language.username_in_use,
                            list: stringSnapshotto.data),
                      ]);
                      return TextFieldContainer(
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              userregistered = value;
                            });
                          },
                          validator: usernameValidator,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: TextStyle(
                              color: textFieldColor,
                              fontWeight: FontWeight.w600),
                          cursorColor: themePrimaryColor,
                          decoration: InputDecoration(
                            errorMaxLines: 2,
                            icon: Icon(
                              Icons.person,
                              color: themePrimaryColor,
                            ),
                            hintText: language.username,
                            hintStyle: TextStyle(
                              fontSize: height * 0.02,
                              fontFamily: 'Quicksand',
                              color: hintTextFieldColor,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      );
                    } else if (stringSnapshotto.hasError) {
                      return Text(stringSnapshotto.error.toString());
                    }
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.amber,
                    ));
                  }),
              RegistrationPasswordField(
                label: language.insert_password,
                onChanged: (value) {
                  setState(() {
                    passwordRegistration = value;
                  });
                },
              ),
              RegistrationPasswordFieldConfirm(
                label: language.confirm_password,
                onChanged: (value) {
                  setState(() {
                    passwordRegistrationConfirm = value;
                  });
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    color: _setRegistrationButtonColor(),
                    onPressed: () async {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());

                      if ((connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi)) {
                        setState(() {
                          if (email != '' &&
                              userregistered != '' &&
                              passwordRegistration != '' &&
                              passwordRegistrationConfirm != '') {
                            username = userregistered;
                            password = passwordRegistration;

                            userlogged = userregistered;

                            showOkAlertDialog(
                                    context: context,
                                    title: language.registration_success)
                                .then((value) {
                              userregistered = '';
                              passwordRegistration = '';
                              passwordRegistrationConfirm = '';
                              email = '';
                              FocusManager.instance.primaryFocus.unfocus();

                              loginUsernameController.clear();

                              loginPasswordController.clear();
                              /*Navigator.popUntil(
                                  context, ModalRoute.withName('/'));*/
                              Navigator.pop(context);
                            });
                          } else {
                            showOkAlertDialog(
                                context: context,
                                title: language.registration_error,
                                message: language.registration_error1);
                          }
                        });
                        try {
                          final FirebaseAuth _auth = FirebaseAuth.instance;

                          firebaseUser =
                              (await _auth.createUserWithEmailAndPassword(
                                      email: email,
                                      password: passwordRegistration))
                                  .user;

                          final userData = UserData(
                              firebaseUser.email,
                              userregistered,
                              "https://abi.ucdavis.edu/sites/g/files/dgvnsk8551/files/inline-images/anonymous%20profile_6.jpg",
                              firebaseUser.uid,
                              passwordRegistration);
                          userDao.saveUser(userData);
                        } catch (e) {
                          print(e);
                        }
                      } else {
                        if (connectivityResult != ConnectivityResult.mobile &&
                            connectivityResult != ConnectivityResult.wifi) {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  content: StatefulBuilder(
                                    builder: (context, setState) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            language.connectivity_error,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    minimumSize: Size(
                                                        width * 0.1,
                                                        height * 0.005),
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    language.no,
                                                    style: TextStyle(
                                                      color:
                                                          themeDialogPrimaryColor,
                                                      fontSize: height * 0.02,
                                                      fontFamily: 'Quicksand',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    minimumSize: Size(
                                                        width * 0.1,
                                                        height * 0.005),
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                  ),
                                                  onPressed: () {
                                                    AppSettings
                                                            .openWIFISettings()
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Text(
                                                    language.go_to_settings,
                                                    style: TextStyle(
                                                      color: themePrimaryColor,
                                                      fontSize: height * 0.02,
                                                      fontFamily: 'Quicksand',
                                                      fontWeight:
                                                          FontWeight.bold,
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
                              });
                        }
                      }
                    },
                    child: Text(
                      language.register,
                      style: TextStyle(
                        color: _setRegistrationButtonTextColor(),
                        fontSize: width * 0.05,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.055,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    language.have_an_account,
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
                      setState(() {
                        isHidden = true;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(language.signin,
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
      //]),
    );
  }

  Color _setRegistrationButtonColor() {
    setState(() {
      if (userregistered.isNotEmpty &&
          regexMail.hasMatch(email) &&
          regexPassword.hasMatch(passwordRegistration) &&
          passwordRegistration == passwordRegistrationConfirm &&
          email != '' &&
          passwordRegistration.isNotEmpty &&
          passwordRegistrationConfirm.isNotEmpty) {
        buttonRegisterColor = themePrimaryColor;
      } else {
        buttonRegisterColor = Colors.grey[300];
      }
    });

    return buttonRegisterColor;
  }

  Color _setRegistrationButtonTextColor() {
    setState(() {
      if (userregistered != '' &&
          regexMail.hasMatch(email) &&
          regexPassword.hasMatch(passwordRegistration) &&
          passwordRegistration == passwordRegistrationConfirm &&
          email != '' &&
          passwordRegistration != '' &&
          passwordRegistrationConfirm != '') {
        buttonRegisterColor = loginRegisterColor;
      } else {
        buttonRegisterColor = Colors.grey;
      }
    });

    return buttonRegisterColor;
  }

  Future<List<String>> getUsernamesInDB() async {
    List<String> list = [];
    var db = FirebaseDatabase.instance.reference().child("users");
    DataSnapshot snapshot = await db.once();
    Map<dynamic, dynamic> values = snapshot.value;

    if (values != null) {
      values.forEach((key, value) {
        list.add(value["username"]);
      });
    }
    return list;
  }

  Future<List<String>> getEmailInDB() async {
    List<String> list = [];
    var db = FirebaseDatabase.instance.reference().child("users");
    DataSnapshot snapshot = await db.once();
    Map<dynamic, dynamic> values = snapshot.value;

    if (values != null) {
      values.forEach((key, value) {
        if (value["email"] != "") {
          list.add(value["email"]);
        }
      });
    }
    return list;
  }
}
