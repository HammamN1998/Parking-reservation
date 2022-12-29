import 'dart:convert';
import 'package:big_cart/models/api_responce_model.dart';
import 'package:big_cart/models/category_model.dart';
import 'package:big_cart/models/product_model.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;

class Api {
  static const String _baseUrl = 'https://technolab4iot.com/parking_reservation/index.php';

  static Future<User> signupUser(
    String email,
    String phone,
    String password,
    String type,
  ) async {
    var signupUrl = Uri.parse(_baseUrl + '/user');
    try {
      http.Response responce = await http.post(
        signupUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode ({
          "email": email,
          "phone": phone,
          "password": password,
          "type": type
        }),
      );
      Map<String, dynamic> json = jsonDecode(responce.body);
      User user =
          ApiResponce<User>.fromJson(json, User.fromJson(json['data'])).data!;
      return user;
    } catch (e) {
      throw (e.toString());
    }
  }

  static Future<User> loginUser(
    String email,
    String password,
  ) async {
    var signinUrl = Uri.parse(_baseUrl + '/user/signin');
    try {
      http.Response responce = await http.post(
        signinUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode ({
          "email": email,
          "password": password,
        }),
      );
      Map<String, dynamic> json = jsonDecode(responce.body);
      User user =
          ApiResponce<User>.fromJson(json, User.fromJson(json['data'])).data!;
      return user;
    } catch (e) {
      throw (e.toString());
    }
  }

  static Future<User> logoutUser(
    String? accessToken,
  ) async {
    var signoutUrl = Uri.parse(_baseUrl + '/user/signout');
    try {
      http.Response responce = await http.get(
        signoutUrl,
        headers: {"Authorization": "Bearer ${accessToken.toString()}"},
      );
      Map<String, dynamic> json = jsonDecode(responce.body);
      User user =
          ApiResponce<User>.fromJson(json, User.fromJson(json['data'])).data!;
      return user;
    } catch (e) {
      throw (e.toString());
    }
  }

  static Future<List<Category>> getParks(String? accessToken) async {
    var parkUrl = Uri.parse(_baseUrl + '/parks');
    try {
      http.Response responce = await http.post(
        parkUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode ({
          "email": accessToken,
        }),
      );
      List<dynamic> json = jsonDecode(responce.body)["data"] as List;

      List<Category> categories =
          json.map((object) => Category.fromJson(object)).toList();
      return categories;
    } catch (e) {
      throw (e.toString());
    }
  }

  static Future<List<Product>> getProducts(String? accessToken) async {
    var productUrl = Uri.parse(_baseUrl + '/parks');
    try {
      http.Response responce = await http.post(
        productUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode ({
          "email": accessToken,
        }),
      );
      List<dynamic> json = jsonDecode(responce.body)["data"];
      List<Product> products =
          json.map((object) => Product.fromJson(object)).toList();
      return products;
    } catch (e) {
      print(e.toString());
      throw (e.toString());
    }
  }

  static Future<List<Product>> getProductsByCategory(
      String? accessToken, int categoryId) async {
    var productUrl = Uri.parse(_baseUrl + '/product/${categoryId.toString()}');
    try {
      http.Response responce = await http.get(productUrl,
          headers: {"Authorization": "Bearer ${accessToken.toString()}"});
      List<dynamic> json = jsonDecode(responce.body)["data"];
      List<Product> products =
          json.map((object) => Product.fromJson(object)).toList();
      return products;
    } catch (e) {
      throw (e.toString());
    }
  }

  static Future<List<Product>> getProductsByTitle(
      String? accessToken, String text) async {
    var productUrl =
        Uri.parse(_baseUrl + '/product/search?q=${text.toString()}');
    try {
      http.Response responce = await http.get(productUrl,
          headers: {"Authorization": "Bearer ${accessToken.toString()}"});
      List<dynamic> json = jsonDecode(responce.body)["data"];
      List<Product> products =
          json.map((object) => Product.fromJson(object)).toList();
      return products;
    } catch (e) {
      throw (e.toString());
    }
  }

  static Future<int> placeOrder(
      String? accessToken,
      String name,
      String email,
      String phno,
      String address,
      String zip,
      String city,
      String country,
      List<Map<String, dynamic>> items) async {
    var orderUrl = Uri.parse(_baseUrl + '/order');
    try {
      http.Response responce = await http.post(
        orderUrl,
        headers: {
          "Authorization": "Bearer ${accessToken.toString()}",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "phoneNumber": phno,
          "address": address,
          "zip": zip,
          "city": city,
          "country": country,
          "items": items,
        }),
      );
      Map<String, dynamic> json = jsonDecode(responce.body)["data"];
      int id = json["id"];
      return id;
    } catch (e) {
      throw (e.toString());
    }
  }
}
