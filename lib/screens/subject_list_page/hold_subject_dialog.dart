import 'package:flutter/material.dart';

class HoldSubjectDialog extends StatefulWidget {
  const HoldSubjectDialog({Key? key}) : super(key: key);

  @override
  _HoldSubjectDialogState createState() => _HoldSubjectDialogState();
}

class _HoldSubjectDialogState extends State<HoldSubjectDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        alignment: Alignment.bottomCenter,
        backgroundColor: Colors.white,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Material(
                color: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.delete_outline_rounded, size: 32),
                        SizedBox(height: 4),
                        Text(
                          "Delete",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.edit_outlined, size: 32),
                        SizedBox(height: 4),
                        Text(
                          "Edit",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.more_horiz, size: 32),
                        SizedBox(height: 4),
                        Text(
                          "More",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
