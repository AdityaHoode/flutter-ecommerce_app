import 'package:ecommerce_app/providers/cartProvider.dart';
import 'package:ecommerce_app/providers/ordersProvider.dart';
import 'package:ecommerce_app/screens/ProductsOverview.dart';
import 'package:provider/provider.dart';
import './screens/ProductDetail.dart';
import 'providers/productsProvider.dart';
import './screens/Cart.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => OrdersProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverview(),
        routes: {
          ProductDetail.routeName: (ctx) => ProductDetail(),
          Cart.routeName: (ctx) => Cart(),
        },
      ),
    );
  }
}
