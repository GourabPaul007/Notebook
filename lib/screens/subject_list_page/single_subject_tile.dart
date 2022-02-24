import 'package:flutter/material.dart';
import 'package:frontend/helpers/acronym.dart';
import 'package:frontend/helpers/change_color.dart';
import 'package:frontend/helpers/date_time.dart';
import 'package:frontend/models/subject_model.dart';

class SingleSubjectTile extends StatelessWidget {
  final Subject subject;

  const SingleSubjectTile({
    Key? key,
    required this.subject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color(subject.avatarColor),
        radius: 24,
        child: Text(
          makeAcronym(subject.name).toUpperCase(),
          style: TextStyle(
            color: darkenColor(Color(subject.avatarColor), 140),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      title: Text(
        subject.name,
        style: Theme.of(context).textTheme.headline4,
      ),
      subtitle: Text(
        subject.description,
        style: Theme.of(context).textTheme.headline5,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            unixToTime(subject.timeUpdated),
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            unixToDate(subject.timeUpdated),
            style: Theme.of(context).textTheme.headline5,
          )
        ],
      ),
    );
    // return Container(
    //   padding: const EdgeInsets.only(left: 12),
    //   margin: const EdgeInsets.only(bottom: 12),
    //   height: 72,
    //   color: Colors.lightBlueAccent,
    //   child: Row(
    //     children: <Widget>[
    //       CircleAvatar(
    //         backgroundColor: Color(subject.avatarColor),
    //         radius: 24,
    //         child: Text(
    //           subject.name[0].toUpperCase(),
    //           style: const TextStyle(
    //             fontSize: 22,
    //             color: Colors.white,
    //           ),
    //         ),
    //       ),
    //       // padding: const EdgeInsets.only(left: 16, top: 14, bottom: 14),
    //       Padding(
    //         padding: const EdgeInsets.only(left: 16.0, top: 12.0),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               subject.name,
    //               style: Theme.of(context).textTheme.headline3,
    //             ),
    //             const SizedBox(
    //               height: 4,
    //             ),
    //             Text(
    //               subject.description,
    //               style: Theme.of(context).textTheme.headline4,
    //             ),
    //           ],
    //         ),
    //       ),
    //       const Expanded(child: SizedBox()),
    //       Padding(
    //         padding: const EdgeInsets.only(right: 8),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: [
    //             Text(
    //               "data",
    //               style: Theme.of(context).textTheme.headline4,
    //             ),
    //             Text(
    //               "data",
    //               style: Theme.of(context).textTheme.headline4,
    //             ),
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
