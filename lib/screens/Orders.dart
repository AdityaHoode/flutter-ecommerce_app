import 'package:ecommerce_app/providers/ordersProvider.dart';
import 'package:ecommerce_app/widgets/AppDrawer.dart';
import 'package:ecommerce_app/widgets/OrderItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Orders extends StatelessWidget {
  static const routeName = '/orders';
  
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, index) {
          return OrderItem(orderData.orders[index]);
        },
      ),
    );
  }
}
