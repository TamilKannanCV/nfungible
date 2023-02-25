import 'dart:convert';

class File {
  String? url;
  String? contentType;

  File({this.url, this.contentType});

  @override
  String toString() => 'File(url: $url, contentType: $contentType)';

  factory File.fromMap(Map<String, dynamic> data) => File(
        url: data['url'] as String?,
        contentType: data['contentType'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'url': url,
        'contentType': contentType,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [File].
  factory File.fromJson(String data) {
    return File.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [File] to a JSON string.
  String toJson() => json.encode(toMap());

  File copyWith({
    String? url,
    String? contentType,
  }) {
    return File(
      url: url ?? this.url,
      contentType: contentType ?? this.contentType,
    );
  }
}
