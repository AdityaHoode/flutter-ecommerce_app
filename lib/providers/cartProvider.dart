import 'package:flutter/cupertino.dart';

class CartItemProvider {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItemProvider({this.id, this.title, this.quantity, this.price});
}

class CartProvider with ChangeNotifier {
  Map<String, CartItemProvider> _cartItems = {};

  Map<String, CartItemProvider> get getCartItem {
    return {..._cartItems};
  }

  int get getItemCount {
    return _cartItems.length;
  }

  double get getTotalAmount {
    var total = 0.0;
    _cartItems.forEach(
      (key, cartItem) {
        total += cartItem.price * cartItem.quantity;
      },
    );
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
        productId,
        (existingCartItem) => CartItemProvider(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartItemProvider(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  void clear() {
    _cartItems = {};
    notifyListeners();
  }
}
