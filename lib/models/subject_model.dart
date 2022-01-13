class Subject {
  final int? rowId;
  final String id;
  late final String name;
  late final String description;
  final String avatarColor;
  final int timeCreated;
  final int timeUpdated;
  // String? imageURL;
  // String? time;
  Subject({
    required this.rowId,
    required this.id,
    required this.name,
    required this.description,
    required this.avatarColor,
    required this.timeCreated,
    required this.timeUpdated,
    // this.message,
    // this.time,
    // @required this.messageText,
    // @required this.imageURL,
    // @required this.time
  });

  factory Subject.fromMap(Map<String, dynamic> json) => Subject(
        rowId: json['row_id'],
        id: json['id'],
        name: json['name'],
        description: json['description'],
        avatarColor: json['avatar_color'],
        timeCreated: json['time_created'],
        timeUpdated: json['time_updated'],
      );

  Map<String, dynamic> toMap() {
    return {
      'row_id': rowId,
      'id': id,
      'name': name,
      'description': description,
      'avatar_color': avatarColor,
      'time_created': timeCreated,
      'time_updated': timeUpdated,
    };
  }
}
