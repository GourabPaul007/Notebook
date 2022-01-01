import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/subject_overview_model.dart';
import 'package:frontend/screens/single_subject.dart';

class SingleSubjectTile extends StatelessWidget {
  final Subject subjectOverview;
  // CameraDescription camera;

  SingleSubjectTile({
    Key? key,
    required this.subjectOverview,
    // required this.camera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          radius: 0,
          splashColor: Colors.red,
          highlightColor: Colors.red,
          onLongPress: () {
            HapticFeedback.vibrate();
          },
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingleSubject(
                  subjectName: subjectOverview.name,
                ),
              ),
            ),
          },
          child: Container(
            padding: const EdgeInsets.only(left: 12),
            height: 80,
            child: Container(
              color: Colors.transparent,
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Color(int.parse(subjectOverview.avatarColor)),
                    radius: 28,
                    child: Text(
                      subjectOverview.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 16),
                    child: Column(
                      children: [
                        Text(
                          subjectOverview.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
