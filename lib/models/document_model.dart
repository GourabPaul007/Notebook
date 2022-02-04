class Document {
  int? rowId;
  final String name;
  final String path;
  final String type;

  /// [size] is Stored as KB
  final int size;
  final int timeAdded;
  final bool isFavourite;

  Document({
    required this.rowId,
    required this.name,
    required this.path,
    required this.size,
    required this.type,
    required this.timeAdded,
    required this.isFavourite,
  });

  factory Document.fromMap(Map<String, dynamic> json) {
    return Document(
      rowId: json['row_id'],
      name: json['name'],
      path: json['path'],
      size: json['size'],
      type: json['type'],
      timeAdded: json['time_added'],
      isFavourite: json['is_favourite'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'path': path,
      'size': size,
      'type': type,
      'time_added': timeAdded,
      'is_favourite': isFavourite,
    };
  }
}
