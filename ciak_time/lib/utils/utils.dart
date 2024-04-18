import 'package:ciak_time/constants.dart';
import 'package:flutter/material.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  _NavbarWidgetState createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  @override
  Widget build(BuildContext context) {
    if (isAndroid) {
      return Container(child: widget.child);
    } else {
      return SizedBox(height: heightNavbar(), child: widget.child);
    }
  }
}

double heightNavbar() {
  double heightNavbar;
  if (isPortrait) {
    heightNavbar = 90;
  } else {
    heightNavbar = 68;
  }
  return heightNavbar;
}

double sizeNavbarSelectedIcons() {
  double sizeSelectedIcons;
  if (isPortrait) {
    sizeSelectedIcons = 24;
  } else {
    sizeSelectedIcons = 20;
  }
  return sizeSelectedIcons;
}

double sizeNavbarUnselectedIcons() {
  double sizeUnselectedIcons;
  if (isPortrait) {
    sizeUnselectedIcons = 20;
  } else {
    sizeUnselectedIcons = 18;
  }
  return sizeUnselectedIcons;
}

double sizeNavbarSelectedFont() {
  double sizeSelectedFont;
  if (isPortrait) {
    sizeSelectedFont = 14;
  } else {
    sizeSelectedFont = 12;
  }
  return sizeSelectedFont;
}

double sizeNavbarUnselectedFont() {
  double sizeUnselectedFont;
  if (isPortrait) {
    sizeUnselectedFont = 12;
  } else {
    sizeUnselectedFont = 10;
  }
  return sizeUnselectedFont;
}

getProfileImage(username, path) {
  if (userlogged == username) {
    return AssetImage(path);
  } else {
    return NetworkImage(path);
  }
}

int setLenght(List list) {
  int len;
  if (isPortrait) {
    if (list.length <= 4) {
      len = list.length;
    } else {
      len = 4;
    }
  } else {
    if (list.length <= 8) {
      len = list.length;
    } else {
      len = 8;
    }
  }
  return len;
}

double heightMovieCards() {
  double heightSize;
  if (isPortrait) {
    heightSize = 160;
  } else {
    heightSize = height * 0.22;
  }
  return heightSize;
}

double widthMovieCards() {
  double widthSize;
  if (isPortrait) {
    widthSize = 110;
  } else {
    widthSize = width * 0.3;
  }
  return widthSize;
}

int setGridNumber() {
  int number;
  if (isPortrait) {
    number = 3;
  } else {
    number = 5;
  }
  return number;
}

double setGridRatio() {
  double ratio;
  if (isPortrait) {
    ratio = 9 / 13;
  } else {
    ratio = 9 / 12;
  }
  return ratio;
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.blue;
  }
  return Colors.red;
}
