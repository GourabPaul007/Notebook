import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repositories/message_repository.dart';
import 'package:frontend/models/message_model.dart';

final starredMessageServiceProvider = ChangeNotifierProvider((ref) => StarredMessageService());

class StarredMessageService extends ChangeNotifier {
  late List<Message> starredMessages = [];

  /// set the [starredMessages] on initial load of [StarredMessagesPage]
  ///
  /// Bug? : If you edit the subject name, old messages will still show old subject name
  Future<void> setStarredMessages(String from, [int subjectRowId = -1]) async {
    starredMessages = await MessageRepository().getStarredMessagesFromLocalDatabase(from, subjectRowId);
    for (var element in starredMessages) {
      debugPrint(element.body +
          "-----" +
          element.isFavourite.toString() +
          "-----" +
          element.title +
          "-----" +
          element.subjectName +
          "-----" +
          element.subjectRowId.toString());
    }
    notifyListeners();
  }
}
