import 'package:ecommerce_app/providers/ordersProvider.dart';
import 'package:ecommerce_app/widgets/AppDrawer.dart';
import 'package:ecommerce_app/widgets/OrderItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Future _fetchOrders;
  Future _callFetchOrders() {
    return Provider.of<OrdersProvider>(context, listen: false).fetchOrders(); // So that fetchOrders is not called everytime the widget rebuilds 
  }

  @override
  void initState() {
    _fetchOrders = _callFetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _fetchOrders,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error == null) {
              return Consumer<OrdersProvider>(
                builder: (ctx, orderData, child) {
                  return ListView.builder(
                    itemCount: orderData.getOrders.length,
                    itemBuilder: (ctx, index) {
                      return OrderItem(orderData.getOrders[index]);
                    },
                  );
                },
              );
            } else {
              return Center(child: Text("Oops! An error occured"));
            }
          }
        },
      ),// This is better than using the isInit & isLoading workaround
    );
  }
}
