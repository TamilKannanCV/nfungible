import 'dart:convert';

import 'file.dart';
import 'poster.dart';

class Content {
  List<File>? files;
  Poster? poster;

  Content({this.files, this.poster});

  @override
  String toString() => 'Content(files: $files, poster: $poster)';

  factory Content.fromMap(Map<String, dynamic> data) => Content(
        files: (data['files'] as List<dynamic>?)
            ?.map((e) => File.fromMap(e as Map<String, dynamic>))
            .toList(),
        poster: data['poster'] == null
            ? null
            : Poster.fromMap(data['poster'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'files': files?.map((e) => e.toMap()).toList(),
        'poster': poster?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Content].
  factory Content.fromJson(String data) {
    return Content.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Content] to a JSON string.
  String toJson() => json.encode(toMap());

  Content copyWith({
    List<File>? files,
    Poster? poster,
  }) {
    return Content(
      files: files ?? this.files,
      poster: poster ?? this.poster,
    );
  }
}
