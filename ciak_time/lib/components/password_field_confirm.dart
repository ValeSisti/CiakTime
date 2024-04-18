import 'package:ciak_time/components/text_field_container.dart';
import 'package:ciak_time/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

class IsMatchValidator extends TextFieldValidator {
  String string;
  String errorText;
  IsMatchValidator(
      {@required this.errorText,
      @required this.string})
      : super('');

  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String value) {
    return string == value;
  }
}

class RegistrationPasswordFieldConfirm extends StatefulWidget {
  final String label;
  final ValueChanged<String> onChanged;

  const RegistrationPasswordFieldConfirm({
    Key key,
    @required this.label,
    this.onChanged,
  }) : super(key: key);

  @override
  _RegistrationPasswordFieldConfirm createState() =>
      _RegistrationPasswordFieldConfirm();
}

class _RegistrationPasswordFieldConfirm
    extends State<RegistrationPasswordFieldConfirm> {
  bool isHidden = true;
  final passwordController = TextEditingController();

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
                controller: passwordController,
                validator: IsMatchValidator(string: passwordRegistration, errorText: language.valid_password),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: isHidden,
                style: TextStyle(
                    color: textFieldColor, fontWeight: FontWeight.w600),
                cursorColor: themePrimaryColor,
                decoration: InputDecoration(
                  errorMaxLines: 2,
                  hintText: widget.label,
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
                autofillHints: [AutofillHints.password],
                onEditingComplete: () => TextInput.finishAutofillContext(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                      minSize: double.minPositive,
                      padding: EdgeInsets.zero,
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
                  CupertinoButton(
                      minSize: double.minPositive,
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                      child: Icon(Icons.info,
                          color: themePrimaryColor, size: height * 0.025),
                      onPressed: () {
                        setState(
                          () {
                            FocusManager.instance.primaryFocus.unfocus();
                            showDialog(
                              context: context,
                              builder: (_) {
                                return new AlertDialog(
                                  content: StatefulBuilder(
                                    builder: (context, setState) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.info,
                                                color: themePrimaryColor,
                                              ),
                                              SizedBox(
                                                width: width * 0.05,
                                              ),
                                              Container(
                                                width: width * 0.5,
                                                child: Text(
                                                  language
                                                      .confirm_password_rules,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: height * 0.02,
                                                    fontFamily: 'Quicksand',
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
      ],
    );
  }

  void togglePasswordVisibility() => setState(() {
        isHidden = !isHidden;
      });
}
