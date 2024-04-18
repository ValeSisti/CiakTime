import 'package:ciak_time/blocs/popular_person_bloc.dart';
import 'package:ciak_time/components/person_card.dart';
import 'package:ciak_time/constants.dart';
import 'package:ciak_time/models/person.dart';
import 'package:ciak_time/models/person_model.dart';
import 'package:flutter/material.dart';

class PopularPeopleList extends StatefulWidget {
  final String fromWhere;

  const PopularPeopleList({Key key, @required this.fromWhere})
      : super(key: key);

  @override
  State<PopularPeopleList> createState() => _PopularPeopleListState();
}

class _PopularPeopleListState extends State<PopularPeopleList> {

  @override
  void initState() {
    bloc.fetchPopularPeople();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.popularPeople,
      builder: (context, AsyncSnapshot<PersonModel> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot);
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

  Widget returnImage(snapshot, index, context) {
    String imagePath;
    if (snapshot.data.results[index].profilePath != null) {
      imagePath =
          'https://image.tmdb.org/t/p/w780${snapshot.data.results[index].profilePath}';
    } else {
      imagePath = user_unknown;
    }
    return GestureDetector(
      onTap: () {
        String fromWhereArg;
        if (widget.fromWhere == "Home") {
          personSelectedFromHome = new Person(
              id: snapshot.data.results[index].id,
              name: snapshot.data.results[index].name);
          fromWhereArg = language.home;
        }
        if (widget.fromWhere == "Search") {
          personSelectedFromSearch = new Person(
              id: snapshot.data.results[index].id,
              name: snapshot.data.results[index].name);
          fromWhereArg = language.search;
        }
        if (widget.fromWhere == "User") {
          personSelectedFromUser = new Person(
              id: snapshot.data.results[index].id,
              name: snapshot.data.results[index].name);
          fromWhereArg = language.user;
        }

        Navigator.pushNamed(context, '/person',
            arguments: ScreenArguments(fromWhereArg));
      },
      child: PersonCard(
        imageUrl: imagePath,
        personName: snapshot.data.results[index].name,
      ),
    );
  }

  Widget buildList(AsyncSnapshot<PersonModel> snapshot) {
    return Container(
      height: height * 0.26,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.results.length,
          itemBuilder: (BuildContext context, int index) {
            return returnImage(snapshot, index, context);
          }),
    );
  }
}
