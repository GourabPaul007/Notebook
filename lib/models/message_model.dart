class Message {
  final String id;
  final String body;
  final String subjectName;
  final int timeCreated;
  final bool? isFavourite;
  Message({
    required this.id,
    required this.body,
    required this.subjectName,
    required this.timeCreated,
    this.isFavourite,
  });

  factory Message.fromMap(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      body: json['body'],
      subjectName: json['subjectName'],
      timeCreated: json['timeCreated'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
      'subjectName': subjectName,
      'timeCreated': timeCreated,
    };
  }
}
