import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ciak_time/Screens/Login/components/background.dart';
import 'package:ciak_time/components/rounded_input_field.dart';
import 'package:ciak_time/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email;

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
                  language.reset_password,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: height * 0.03,
                      fontFamily: 'Quicksand-Medium',
                      color: themePrimaryColor),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              RoundedInputField(
                hintText: language.email,
                onChanged: (value) {
                  setState(() {
                    _email = value;
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
                    color: changeResetColor(),
                    onPressed: () async {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());

                      if ((connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi)) {
                        try {
                          await _auth.sendPasswordResetEmail(email: _email);
                          Fluttertoast.showToast(
                            msg: language.email_sent,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                            backgroundColor: themeToastColor,
                            textColor: Colors.black,
                            fontSize: 16.0,
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
                          showOkAlertDialog(
                              context: context,
                              title: language.email_invalid,
                              message: language.email_invalid_2);
                        }
                      } else {
                        if (connectivityResult != ConnectivityResult.mobile &&
                            connectivityResult != ConnectivityResult.wifi) {
                          showOkAlertDialog(
                              context: context,
                              title: language.connectivity_error,
                              message: language.connectivity_error_message);
                        }
                      }
                    },
                    child: Text(
                      language.send_password_reset_email,
                      style: TextStyle(
                        color: changeResetTextColor(),
                        fontSize: width * 0.05,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      primary: Colors.transparent,
                      minimumSize: Size(width * 0.1, height * 0.005),
                      padding: EdgeInsets.all(0.0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(language.back_to_login,
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

  Color changeResetColor() {
    setState(() {
      if (_email != '' && _email != null) {
        emailConfirmColor = themePrimaryColor;
      } else {
        emailConfirmColor = Colors.grey[300];
      }
    });

    return emailConfirmColor;
  }

  Color changeResetTextColor() {
    setState(() {
      if (_email != '' && _email != null) {
        emailTextConfirmColor = loginRegisterColor;
      } else {
        emailTextConfirmColor = Colors.grey;
      }
    });

    return emailTextConfirmColor;
  }
}
