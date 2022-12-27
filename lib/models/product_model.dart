class Product {

  int? id;
  String? floor;
  String? state;
  String? waitingListsInside;
  int? userId;


  Product(
      {this.id,
      this.floor,
      this.userId,
      this.state,
      });

  Product.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    floor = json['floor'].toString();
    state = json['state'];
    waitingListsInside = json['waiting_lists_number'].toString();
    userId = int.parse(json['user_id'].toString() != 'null' ? json['user_id'].toString() : '-1');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['floor'] = this.floor;
    data['state'] = this.state;
    data['waiting_lists_number'] = this.waitingListsInside;
    data['user_id'] = this.userId.toString();
    return data;
  }
}
