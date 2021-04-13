import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ProductItem.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;
  ProductsGrid(this.showFavorites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final items = showFavorites ? productsData.getFavItems : productsData.getItems;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: items[index],
          child: ProductItem(),
        );
      },
      itemCount: items.length,
    );
  }
}
