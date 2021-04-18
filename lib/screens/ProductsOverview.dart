import 'package:ecommerce_app/providers/cartProvider.dart';
import 'package:ecommerce_app/screens/Cart.dart';
import 'package:ecommerce_app/widgets/Badge.dart';
import 'package:provider/provider.dart';

import '../widgets/ProductsGrid.dart';
import 'package:flutter/material.dart';

enum FilterOptions { Favorites, All }

class ProductsOverview extends StatefulWidget {
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showFavorites = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Shop"),
          actions: [
            PopupMenuButton(
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Favorites'),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text('Show all'),
                  value: FilterOptions.All,
                ),
              ],
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showFavorites = true;
                  } else {
                    _showFavorites = false;
                  }
                });
              },
            ),
            Consumer<CartProvider>(
              builder: (_, cartItems, ch) => Badge(
                child: ch,
                value: cartItems.getItemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.of(context).pushNamed(Cart.routeName);
                },
              ),
            ),
          ],
        ),
        body: ProductsGrid(_showFavorites),
      ),
    );
  }
}
