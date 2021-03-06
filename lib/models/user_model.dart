import 'package:big_cart/models/api_responce_model.dart';

class User implements ApiDataModel {
  int? id;
  String? email;
  String? phone;
  String? password;
  String? type;
  String? accessToken;

  User({this.id, this.email, this.phone, this.password, this.accessToken, this.type});

  User.fromJson(dynamic json) {
    id = int.parse(json['id'].toString());
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    type = json['type'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['type'] = this.type;
    data['accessToken'] = this.accessToken;
    return data;
  }
}
