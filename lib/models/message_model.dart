class Message {
  late final int? rowId;
  final String id;
  String title;
  String body;
  // final String subjectName;
  final int subjectRowId;
  final int timeCreated;
  int timeUpdated;
  bool isFavourite;
  final bool isText;
  final bool isImage;

  Message({
    required this.rowId,
    required this.id,
    required this.title,
    required this.body,
    // required this.subjectName,
    required this.subjectRowId,
    required this.timeCreated,
    required this.timeUpdated,
    required this.isFavourite,
    required this.isText,
    required this.isImage,
  });

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        rowId: json["row_id"],
        id: json['id'],
        title: json['title'],
        body: json['body'],
        // subjectName: json['subject_name'],
        subjectRowId: json['subject_row_id'],
        timeCreated: json['time_created'],
        timeUpdated: json['time_updated'],
        isFavourite: json['is_favourite'] == 1 ? true : false,
        isText: json['is_text'] == 1 ? true : false,
        isImage: json['is_image'] == 1 ? true : false,
      );

  Map<String, dynamic> toMap() {
    return {
      // 'row_id': rowId,
      'id': id,
      'title': title,
      'body': body,
      // 'subject_name': subjectName,
      'subject_row_id': subjectRowId,
      'time_created': timeCreated,
      'time_updated': timeUpdated,
      'is_favourite': isFavourite,
      'is_text': isText,
      'is_image': isImage,
    };
  }
}
