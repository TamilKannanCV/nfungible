import 'dart:convert';

class Set {
  DateTime? createdAt;
  String? id;
  dynamic image;
  String? state;
  dynamic status;
  String? title;
  DateTime? updatedAt;

  Set({
    this.createdAt,
    this.id,
    this.image,
    this.state,
    this.status,
    this.title,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'Set(createdAt: $createdAt, id: $id, image: $image, state: $state, status: $status, title: $title, updatedAt: $updatedAt)';
  }

  factory Set.fromMap(Map<String, dynamic> data) => Set(
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        id: data['id'] as String?,
        image: data['image'] as dynamic,
        state: data['state'] as String?,
        status: data['status'] as dynamic,
        title: data['title'] as String?,
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
      );

  Map<String, dynamic> toMap() => {
        'createdAt': createdAt?.toIso8601String(),
        'id': id,
        'image': image,
        'state': state,
        'status': status,
        'title': title,
        'updatedAt': updatedAt?.toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Set].
  factory Set.fromJson(String data) {
    return Set.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Set] to a JSON string.
  String toJson() => json.encode(toMap());

  Set copyWith({
    DateTime? createdAt,
    String? id,
    dynamic image,
    String? state,
    dynamic status,
    String? title,
    DateTime? updatedAt,
  }) {
    return Set(
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      image: image ?? this.image,
      state: state ?? this.state,
      status: status ?? this.status,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
