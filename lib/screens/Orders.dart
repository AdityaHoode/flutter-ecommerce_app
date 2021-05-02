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
  var isLoading = false;
  var isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<OrdersProvider>(context, listen: false)
          .fetchOrders()
          .then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderData.getOrders.length,
              itemBuilder: (ctx, index) {
                return OrderItem(orderData.getOrders[index]);
              },
            ),
    );
  }
}
