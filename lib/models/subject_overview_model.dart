import 'dart:ui';

class Subject {
  // final int id;
  String name;
  String avatarColor;
  // String? message;
  // String? time;
  // String? messageText;
  // String? imageURL;
  // String? time;
  Subject({
    // required this.id,
    required this.name,
    required this.avatarColor,
    // this.message,
    // this.time,
    // @required this.messageText,
    // @required this.imageURL,
    // @required this.time
  });

  factory Subject.fromMap(Map<String, dynamic> json) => Subject(
        name: json['name'],
        avatarColor: json['avatarColor'],
      );

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': name,
      'avatarColor': avatarColor,
    };
  }
}
