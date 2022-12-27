import 'package:big_cart/models/product_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CartService {
  List<Product> _cart = <Product>[];
  List<Product> get cart => _cart;

  List<Product> _favorites = <Product>[];
  List<Product> get favorites => _favorites;

  void addProduct(Product product) {
    int index = _cart.indexWhere((element) => element.id == product.id);
    _cart.add(product);

  }

  void removeProduct(Product product) {
    int index = _cart.indexWhere((element) => element.id == product.id);
    if (index != -1) {
      deleteProduct(_cart[index]);

    }
  }

  void deleteProduct(Product product) {
    int index = _cart.indexWhere((element) => element.id == product.id);
    if (index != -1) {
      _cart.removeAt(index);
    }
  }

  void clearCart() {
    _cart = <Product>[];
  }

  int getQuantityFromProduct(Product product) {
    int index = _cart.indexWhere((element) => element.id == product.id);
    return 0;

  }

  void addOrRemoveFavorites(Product product) {
    int index = _favorites.indexWhere((element) => element.id == product.id);
    if (index == -1) {
      _favorites.add(product);
    } else {
      _favorites.removeAt(index);
    }
  }
}
