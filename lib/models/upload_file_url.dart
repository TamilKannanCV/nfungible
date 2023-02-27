import 'dart:convert';

class UploadFileUrl {
  String? id;
  String? name;
  String? url;
  String? state;

  UploadFileUrl({this.id, this.name, this.url, this.state});

  @override
  String toString() {
    return 'UploadFileUrl(id: $id, name: $name, url: $url, state: $state)';
  }

  factory UploadFileUrl.fromMap(Map<String, dynamic> data) => UploadFileUrl(
        id: data['id'] as String?,
        name: data['name'] as String?,
        url: data['url'] as String?,
        state: data['state'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'url': url,
        'state': state,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UploadFileUrl].
  factory UploadFileUrl.fromJson(String data) {
    return UploadFileUrl.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UploadFileUrl] to a JSON string.
  String toJson() => json.encode(toMap());
}
