import 'package:ecommerce_app/screens/EditProduct.dart';
import 'package:ecommerce_app/widgets/AppDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_app/providers/productsProvider.dart';
import 'package:ecommerce_app/widgets/UserProductItem.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _onRefresh(BuildContext context) async {
    await Provider.of<Products>(context,listen: false).getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProduct.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
              child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: productsData.getItems.length,
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  UserProductItem(
                    productsData.getItems[index].id,
                    productsData.getItems[index].title,
                    productsData.getItems[index].imageUrl,
                  ),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
