import 'dart:convert';

class Poster {
  String? url;

  Poster({this.url});

  @override
  String toString() => 'Poster(url: $url)';

  factory Poster.fromMap(Map<String, dynamic> data) => Poster(
        url: data['url'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'url': url,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Poster].
  factory Poster.fromJson(String data) {
    return Poster.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Poster] to a JSON string.
  String toJson() => json.encode(toMap());

  Poster copyWith({
    String? url,
  }) {
    return Poster(
      url: url ?? this.url,
    );
  }
}
