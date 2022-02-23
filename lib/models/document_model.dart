class Document {
  int? rowId;
  String name;
  final String path;
  final String type;
  int color;

  /// [size] is Stored as KB
  final int size;
  final int timeAdded;
  int timeUpdated;
  final bool isFavourite;

  Document({
    required this.rowId,
    required this.name,
    required this.path,
    required this.color,
    required this.size,
    required this.type,
    required this.timeAdded,
    required this.timeUpdated,
    required this.isFavourite,
  });

  factory Document.fromMap(Map<String, dynamic> json) {
    return Document(
      rowId: json['row_id'],
      name: json['name'],
      path: json['path'],
      color: json['color'],
      size: json['size'],
      type: json['type'],
      timeAdded: json['time_added'],
      timeUpdated: json['time_updated'],
      isFavourite: json['is_favourite'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'path': path,
      'color': color,
      'size': size,
      'type': type,
      'time_added': timeAdded,
      'time_updated': timeUpdated,
      'is_favourite': isFavourite,
    };
  }
}
