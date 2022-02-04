import 'package:flutter/material.dart';
import 'package:frontend/models/subject_model.dart';

class SingleSubjectTile extends StatelessWidget {
  final Subject subject;

  const SingleSubjectTile({
    Key? key,
    required this.subject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Each Chat Container
      padding: const EdgeInsets.only(left: 12),
      height: 80,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Color(int.parse(subject.avatarColor)),
            radius: 28,
            child: Text(
              subject.name[0].toUpperCase() == "" ? "X" : subject.name[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 14, bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  subject.description,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    //   ),
    // );
  }
}
