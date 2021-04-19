import 'package:ecommerce_app/providers/cartProvider.dart';
import 'package:flutter/foundation.dart';

class OrderItemProvider {
  final String id;
  final double amount;
  final List<CartItemProvider> products;
  final DateTime dateTime;

  OrderItemProvider({this.id, this.products, this.amount, this.dateTime});
}

class OrdersProvider with ChangeNotifier {
  List<OrderItemProvider> _orders = [];

  List<OrderItemProvider> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItemProvider> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItemProvider(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
