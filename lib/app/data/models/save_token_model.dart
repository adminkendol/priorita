class SaveToken {
  Metadata? metadata;

  SaveToken({this.metadata});

  SaveToken.fromJson(Map<String, dynamic> json) {
    metadata =
        json['metadata'] != null ? Metadata?.fromJson(json['metadata']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (metadata != null) {
      data['metadata'] = metadata?.toJson();
    }
    return data;
  }
}

class Metadata {
  String? message;
  int? code;

  Metadata({this.message, this.code});

  Metadata.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    data['code'] = code;
    return data;
  }
}
