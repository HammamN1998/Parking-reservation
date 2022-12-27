import 'package:big_cart/models/api_responce_model.dart';

class Category extends ApiDataModel {
  int? id;
  String? floor;
  String? state;
  String? waitingListsInside;
  int? userId;

  Category({this.id, this.floor, this.state, this.userId});

  Category.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    floor = json['floor'];
    state = json['state'];
    waitingListsInside = json['waiting_lists_number'].toString();
    userId = int.parse(json['user_id'].toString() != 'null' ? json['user_id'].toString() : '-1');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['floor'] = this.floor.toString();
    data['state'] = this.state.toString();
    data['waiting_lists_number'] = this.state.toString();
    data['user_id'] = this.userId.toString();
    return data;
  }
}
