class ErrorResponse {
  int? statusCode;
  String? error;
  List<ErrorMessage>? messages;
  List<Data>? data;

  ErrorResponse({
    this.statusCode,
    this.error,
    this.messages,
    this.data});

  ErrorResponse.fromJson(dynamic json) {
    statusCode = json["statusCode"];
    error = json["error"];
    if (json["message"] != null) {
      messages = [];
      if(json["message"] is List) {
        json["message"].forEach((v) {
          messages?.add(ErrorMessage.fromJson(v));
        });
      } else {
        messages?.add(ErrorMessage(message: json["message"]));
      }
    }
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["statusCode"] = statusCode;
    map["error"] = error;
    if (messages != null) {
      map["message"] = messages?.map((v) => v.toJson()).toList();
    }
    if (data != null) {
      map["data"] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  List<Messages>? messages;

  Data({
    this.messages});

  Data.fromJson(dynamic json) {
    if (json["messages"] != null) {
      messages = [];
      json["messages"].forEach((v) {
        messages?.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (messages != null) {
      map["messages"] = messages?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Messages {
  String? id;
  String? message;
  int? field;

  Messages({
    this.id,
    this.message,
    this.field
  });

  Messages.fromJson(dynamic json) {
    id = json["id"];
    message = json["message"];
    field = json['field'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["message"] = message;
    map['field'] = field;
    return map;
  }

}

class Message {
  List<Messages>? messages;

  Message({
    this.messages});

  Message.fromJson(dynamic json) {
    if (json["messages"] != null) {
      messages = [];
      json["messages"].forEach((v) {
        messages?.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (messages != null) {
      map["messages"] = messages?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class ErrorMessage {
  String? id;
  String? message;
  int? field;

  ErrorMessage({
    this.id,
    this.message});

  ErrorMessage.fromJson(dynamic json) {
    id = json["id"];
    message = json["message"];
    field = json['field'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["message"] = message;
    map['field'] = field;
    return map;
  }

}