class GetToken {
  Res? response;
  Metadata? metadata;

  GetToken({this.response, this.metadata});

  GetToken.fromJson(Map<String, dynamic> json) {
    response =
        json['response'] != null ? Res?.fromJson(json['response']) : null;
    metadata =
        json['metadata'] != null ? Metadata?.fromJson(json['metadata']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response?.toJson();
    }
    if (metadata != null) {
      data['metadata'] = metadata?.toJson();
    }
    return data;
  }
}

class Res {
  String? token;

  Res({this.token});

  Res.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = token;
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
