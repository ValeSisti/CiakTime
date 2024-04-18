import 'dart:io';
import 'package:ciak_time/Screens/Review/review_object.dart';
import 'package:ciak_time/Screens/Search/components/cards_widget.dart';
import 'package:ciak_time/Screens/User/notification_object.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/person.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);
Color navBarColor = Colors.deepPurpleAccent[100];
Color tabBarColor = Color(0xffa16ad4);

var height;
var width;

bool isAndroid;
bool notification = false;

String user_unknown =
    "https://abi.ucdavis.edu/sites/g/files/dgvnsk8551/files/inline-images/anonymous%20profile_6.jpg";

bool showingDialog = false;

Color buttonModifyUserColor = kPrimaryColor;
Color buttonModifyUserTextColor = Colors.white;

Color buttonPasswordColor = kPrimaryColor;
Color buttonPasswordTextColor = Colors.white;

ConnectivityResult globalResult;

Color buttonRegisterColor = kPrimaryColor;
Color buttonRegisterTextColor = Colors.white;

Color saveColor = kPrimaryColor;
Color saveTextColor = Colors.white;
String likeDislikeText = "";

Color loginColor = Colors.grey[300];
Color loginTextColor = Colors.grey;

Color emailConfirmColor = Colors.grey[300];
Color emailTextConfirmColor = Colors.grey;

var language;

Locale locale;

String api_language;

Color scaffoldBackgroundColor = Colors.white;
Color themePrimaryColor = kPrimaryColor;
Color themeSecondaryColor = kPrimaryLightColor;
Color themeDialogPrimaryColor = Colors.black;
Color themeDividerColor = Color(0xFFD9D9D9);
Color themeSecondaryTextColor = Colors.black54;
Color themeIconColor = Colors.white;
Color themeToastColor = kPrimaryLightColor;

Color textFieldColor = Colors.black;
Color hintTextFieldColor = Colors.black54;

Color loginRegisterColor = Colors.white;

Color shadowColor = Colors.transparent;

Color ratingColor = Colors.grey.withOpacity(0.5);

Color backGroundNavbar = kPrimaryColor;
Color selectedItem = Colors.white;
Color unselectedItemNavbar = navBarColor;

Color searchBarColor = kPrimaryColor;
Color hintColor = navBarColor;
Color tabColor = tabBarColor;
Color unselectedLabelColor = kPrimaryLightColor;

bool noPressed = false;
bool error = false;

bool isReviewed = false;

bool showBottomNavbar = true;

bool isDarkMode;

var isPortrait;

CircleAvatar profilePicture;

String picturePath = "";

Widget home;

Pattern passwordPattern = r'(?=.*?[#?!@$%^&*-_])';
Pattern emailPattern =
    r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";

Color dividerColor = Colors.amber;

TextEditingController loginPasswordController = TextEditingController();
TextEditingController loginUsernameController = TextEditingController();
TextEditingController emailResetPasswordController = TextEditingController();

bool userEnabled = false;
bool passwordEnabled = false;

bool selected_rate = false;
bool selected_most_added = false;
bool selected_most_recent = false;

bool drama = false;
bool comedy = false;
bool action = false;
bool crime = false;
bool fantasy = false;
bool thriller = false;
bool family = false;
bool anime = false;
bool horror = false;

bool add_movie = false;

bool isReset = false;

bool googleConnected = false;
bool facebookConnected = false;
bool emailAndPasswordConnected = false;

bool isMovieChecked = true;
bool isPersonChecked = false;

Color colorRate = Colors.black;
Color colorMostAdded = Colors.black;
Color colorMostRecent = Colors.black;
Color colorDrama = Colors.black;
Color colorComedy = Colors.black;
Color colorAction = Colors.black;
Color colorCrime = Colors.black;
Color colorFantasy = Colors.black;
Color colorThriller = Colors.black;
Color colorFamily = Colors.black;
Color colorAnime = Colors.black;
Color colorHorror = Colors.black;
Color filterTitleColor = kPrimaryColor;
Color filterSelectedColor = kPrimaryColor;
Color borderFilterColor = kPrimaryColor;
Color resetColor = Colors.amber;
Color resetBackgroundColor = Colors.white;
Color resetBorderColor = Colors.amber;
Color showResultColor = Colors.white;

Color applyColor = kPrimaryLightColor;
Color applyTextColor = Colors.grey;

Movie movieSelectedFromHome;
Movie movieSelectedFromSearch;
Movie movieSelectedFromUser;

Person personSelectedFromHome;
Person personSelectedFromSearch;
Person personSelectedFromUser;

Movie personMovieSelectedFromHome;
Movie personMovieSelectedFromSearch;
Movie personMovieSelectedFromUser;

List<Movie> selectedPersonMoviesFromHome = [];
List<Movie> selectedPersonMoviesFromSearch = [];
List<Movie> selectedPersonMoviesFromUser = [];

String watchListTitle = "Add to watchlist";
String alreadyWatchedListTitle = "Add to already watched list";
String favouriteListTitle = "Add to favourite list";

List<int> filteredMoviesList = [];

double newRating = 0;

int reviewIndex;
List<ReviewObject> reviewsListReversed;
int notificationIndex;
List<NotificationObject> notificationListReversed;

String profilePicPath;
File image;
bool isFromGallery = false;
String tabSelected = "Movie";

Widget content = CardsWidget();

List<String> users = [];
List<String> emails = [];

String username = '';
String password = '';

bool isHidden = true;

String loginEmail = '';
String loginPassword = '';

User firebaseUser;

String newPassword = '';
String newConfirmPassword = '';
String oldPassword = '';

String review;

String profilePicUrl = '';

String userId = '';

String userlogged = '';
String usermodified = '';
String userregistered = '';
String email = '';
String passwordRegistration = '';
String passwordRegistrationConfirm = '';
RegExp regexMail = new RegExp(emailPattern);
RegExp regexPassword = new RegExp(passwordPattern);

bool isCommentConfirmed = false;

List genresIds = [
  {
    'Action': 28,
    'Animation': 16,
    'Comedy': 35,
    'Crime': 80,
    'Drama': 18,
    'Family': 10751,
    'Fantasy': 14,
    'Horror': 27,
    'Thriller': 53,
  }
];

class ScreenArguments {
  final String fromWhere;

  ScreenArguments(this.fromWhere);
}
