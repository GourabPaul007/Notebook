class Message {
  final int? rowId;
  final String id;
  final String body;
  final String subjectName;
  final int subjectRowId;
  final int timeCreated;
  final int timeUpdated;
  final bool? isFavourite;
  Message({
    required this.rowId,
    required this.id,
    required this.body,
    required this.subjectName,
    required this.subjectRowId,
    required this.timeCreated,
    required this.timeUpdated,
    this.isFavourite,
  });

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        rowId: json["row_id"],
        id: json['id'],
        body: json['body'],
        subjectName: json['subject_name'],
        subjectRowId: json['subject_row_id'],
        timeCreated: json['time_created'],
        timeUpdated: json['time_updated'],
      );

  Map<String, dynamic> toMap() {
    return {
      // 'row_id': rowId,
      'id': id,
      'body': body,
      'subject_name': subjectName,
      'subject_row_id': subjectRowId,
      'time_created': timeCreated,
      'time_updated': timeUpdated,
    };
  }
}
