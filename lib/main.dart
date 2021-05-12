import 'package:ecommerce_app/providers/authProvider.dart';
import 'package:ecommerce_app/providers/cartProvider.dart';
import 'package:ecommerce_app/providers/ordersProvider.dart';
import 'package:ecommerce_app/screens/AuthScreen.dart';
import 'package:ecommerce_app/screens/EditProduct.dart';
import 'package:ecommerce_app/screens/Orders.dart';
import 'package:ecommerce_app/screens/ProductsOverview.dart';
import 'package:ecommerce_app/screens/SplashScreen.dart';
import 'package:ecommerce_app/screens/UserProducts.dart';
import './screens/ProductDetail.dart';
import 'providers/productsProvider.dart';
import './screens/Cart.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future main() async {
  await DotEnv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => AuthProvider()),
          ChangeNotifierProxyProvider<AuthProvider, Products>(
            update: (ctx, authData, previousProductsData) => Products(
              authData.getToken,
              authData.getUserId,
              previousProductsData == null ? [] : previousProductsData.getItems,
            ),
          ),
          ChangeNotifierProvider(create: (ctx) => CartProvider()),
          ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
            update: (ctx, authData, previousOrdersData) => OrdersProvider(
              authData.getToken,
              authData.getUserId,
              previousOrdersData == null ? [] : previousOrdersData.getOrders,
            ),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (ctx, authData, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: authData.getIsAuth
                ? ProductsOverview()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetail.routeName: (ctx) => ProductDetail(),
              Cart.routeName: (ctx) => Cart(),
              Orders.routeName: (ctx) => Orders(),
              UserProducts.routeName: (ctx) => UserProducts(),
              EditProduct.routeName: (ctx) => EditProduct(),
            },
          ),
        ));
  }
}
