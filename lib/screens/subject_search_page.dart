import 'package:flutter/material.dart';
import 'package:frontend/models/subject_model.dart';
import 'package:frontend/screens/subject_list_page/single_subject_tile.dart';

class SubjectSearchPage extends SearchDelegate {
  List<Subject> subjects;
  SubjectSearchPage(this.subjects);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.ac_unit,
          color: Colors.black,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Subject> matchQuery = [];
    for (var s in subjects) {
      if (s.name.toLowerCase().contains(query.toLowerCase()) ||
          s.description.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(s);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (BuildContext context, int index) {
        var result = matchQuery[index];
        return SingleSubjectTile(subject: result);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Subject> matchQuery = [];
    for (var s in subjects) {
      if (s.name.toLowerCase().contains(query.toLowerCase()) ||
          s.description.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(s);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (BuildContext context, int index) {
        var result = matchQuery[index];
        return SingleSubjectTile(subject: result);
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    super.appBarTheme(context);
    // final ThemeData theme = Theme.of(context);
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(color: Theme.of(context).backgroundColor, elevation: 0),
      inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none),
      scaffoldBackgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
