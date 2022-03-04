/// [type] is one of ['text','image','document']
class Message {
  late final int? rowId;
  final String id;
  String title;
  String body;
  String path;
  int color;
  String subjectName;
  final int subjectRowId;
  final int timeCreated;
  int timeUpdated;
  bool isFavourite;
  final String type;

  Message({
    required this.rowId,
    required this.id,
    required this.title,
    required this.body,
    required this.path,
    required this.color,
    required this.subjectName,
    required this.subjectRowId,
    required this.timeCreated,
    required this.timeUpdated,
    required this.isFavourite,
    required this.type,
  });

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        rowId: json["row_id"],
        id: json['id'],
        title: json['title'],
        body: json['body'],
        path: json['path'],
        color: json['color'],
        subjectName: json['subject_name'],
        subjectRowId: json['subject_row_id'],
        timeCreated: json['time_created'],
        timeUpdated: json['time_updated'],
        isFavourite: json['is_favourite'] == 1 ? true : false,
        type: json['type'],
      );

  Map<String, dynamic> toMap() {
    return {
      // 'row_id': rowId,
      'id': id,
      'title': title,
      'body': body,
      'path': path,
      'color': color,
      'subject_name': subjectName,
      'subject_row_id': subjectRowId,
      'time_created': timeCreated,
      'time_updated': timeUpdated,
      'is_favourite': isFavourite,
      'type': type,
    };
  }
}
