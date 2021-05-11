import 'package:ecommerce_app/providers/cartProvider.dart';
import 'package:ecommerce_app/screens/Orders.dart';
import 'package:ecommerce_app/widgets/CartItem.dart';
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

  final String authToken;
  final String userId;

  OrdersProvider(this.authToken, this.userId, this._orders);

  List<OrderItemProvider> get getOrders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://flutter-ecommerce-app-42497-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final res = await http.get(url);
    final fetchedOrders = json.decode(res.body) as Map<String, dynamic>;
    final List<OrderItemProvider> loadedOrders = [];
    if (fetchedOrders == null) {
      return;
    }
    fetchedOrders.forEach(
      (oId, oData) => loadedOrders.add(
        OrderItemProvider(
          id: oId,
          amount: oData['amount'],
          dateTime: DateTime.parse(oData['dateTime']),
          products: (oData['products'] as List<dynamic>)
              .map(
                (e) => CartItemProvider(
                  id: e['id'],
                  title: e['title'],
                  price: e['price'],
                  quantity: e['quantity'],
                ),
              )
              .toList(),
        ),
      ),
    );
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(
      List<CartItemProvider> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flutter-ecommerce-app-42497-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
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
