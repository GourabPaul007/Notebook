class Document {
  int? rowId;
  String name;
  String about;
  String thumbnailPath;
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
    required this.about,
    required this.thumbnailPath,
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
      about: json['about'],
      thumbnailPath: json['thumbnail_path'],
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
      'about': about,
      'thumbnail_path': thumbnailPath,
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
