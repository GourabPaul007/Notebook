import 'package:flutter/material.dart';

class DetailsDialog extends StatelessWidget {
  /// type can either be one of message/subject/book
  final String type;
  const DetailsDialog({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Column(
          children: const [Text("data")],
        ),
      ),
    );
  }
}
