import 'package:ciak_time/components/text_field_container.dart';
import 'package:ciak_time/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _RoundedPasswordField createState() => _RoundedPasswordField();
}

class _RoundedPasswordField extends State<RoundedPasswordField> {
  String password;
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        TextFieldContainer(
          child: Stack(
            alignment: Alignment.centerRight,
            children: <Widget>[
              TextFormField(
                onChanged: widget.onChanged,
                controller: loginPasswordController,
                obscureText: isHidden,
                style: TextStyle(
                    color: textFieldColor, fontWeight: FontWeight.w600),
                cursorColor: themePrimaryColor,
                decoration: InputDecoration(
                  hintText: language.password,
                  hintStyle: TextStyle(
                    fontSize: height * 0.02,
                    fontFamily: 'Quicksand',
                    color: hintTextFieldColor,
                  ),
                  icon: Icon(
                    Icons.lock,
                    color: themePrimaryColor,
                  ),
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
              CupertinoButton(
                  minSize: double.minPositive,
                  child: isHidden
                      ? Icon(Icons.visibility_off,
                          color: themePrimaryColor, size: height * 0.025)
                      : Icon(Icons.visibility,
                          color: themePrimaryColor, size: height * 0.025),
                  onPressed: () {
                    setState(() {
                      togglePasswordVisibility();
                    });
                  }),
            ],
          ),
        ),
      ],
    );
  }

  void togglePasswordVisibility() => setState(() {
        isHidden = !isHidden;
      });
}
