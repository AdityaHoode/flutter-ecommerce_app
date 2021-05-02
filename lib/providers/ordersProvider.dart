import 'package:ecommerce_app/providers/cartProvider.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<void> addOrder(
      List<CartItemProvider> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flutter-ecommerce-app-42497-default-rtdb.firebaseio.com/orders.json');
    var timeStamp = DateTime.now();
    final res = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map(
                (e) => {
                  'id': e.id,
                  'title': e.title,
                  'quantity': e.quantity,
                  'price': e.price,
                },
              )
              .toList()
        }));
    _orders.insert(
      0,
      OrderItemProvider(
        id: json.decode(res.body)['name'],
        amount: total,
        dateTime: timeStamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
