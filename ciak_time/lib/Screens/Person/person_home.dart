import 'package:ciak_time/Screens/Person/filmography_list.dart';
import 'package:ciak_time/Screens/Person/person_utils.dart';
import 'package:ciak_time/blocs/person_details_bloc.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/movie.dart';
import 'package:ciak_time/models/person_details_model.dart';
import 'package:flutter/material.dart';

List<Movie> list;

class PersonHome extends StatefulWidget {
  const PersonHome({
    Key key,
  }) : super(key: key);

  @override
  _PersonHomeState createState() => _PersonHomeState();
}

class _PersonHomeState extends State<PersonHome> {
  PersonDetailsBloc bloc;
  @override
  void initState() {
    bloc = PersonDetailsBloc(personSelectedFromHome.id.toString());
    bloc.fetchPersonDetailsResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;

    return StreamBuilder(
      stream: bloc.personDetails,
      builder: (context, AsyncSnapshot<PersonDetailsModel> snapshot) {
        if (snapshot.hasData) {
          return buildPersonDetails(snapshot, args);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return Center(
            child: CircularProgressIndicator(
          color: Colors.amber,
        ));
      },
    );
  }

  Widget buildPersonDetails(AsyncSnapshot<PersonDetailsModel> snapshot, args) {
    String imagePath;
    if (snapshot.data.profilePath == null) {
      imagePath = user_unknown;
    } else if (snapshot.data.profilePath.length != 0) {
      imagePath = 'https://image.tmdb.org/t/p/w780${snapshot.data.profilePath}';
    } else {
      imagePath = user_unknown;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        leadingWidth: 40,
        title: Text(
          personSelectedFromHome.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(imagePath),
                          radius: width * 0.2,
                        ),
                        SizedBox(width: width * 0.05),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                personSelectedFromHome.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Quicksand',
                                    fontSize: height * 0.03),
                              ),
                              SizedBox(height: height * 0.01),
                              BornInfo(
                                date: snapshot.data.birthday,
                                place: snapshot.data.placeOfBirth,
                              ),
                              SizedBox(height: height * 0.01),
                              DeathInfo(date: snapshot.data.deathday),
                              OccupationInfo(
                                  know_for: snapshot.data.knownForDepartment),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Divider(color: Colors.grey[700]),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(language.biography,
                      style: TextStyle(
                          color: themePrimaryColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Quicksand',
                          fontSize: height * 0.025)),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Biography(biography: snapshot.data.biography),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Divider(color: themeDividerColor),
                  FilmographyList(
                    fromWhere: "Home",
                  ),
                  Divider(color: themeDividerColor),
                ]),
          ),
        ),
      ),
    );
  }
}
