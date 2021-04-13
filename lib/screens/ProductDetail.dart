import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final pId = ModalRoute.of(context).settings.arguments as String;
    final clickedProduct = Provider.of<Products>(context,listen: false)
        .getItems
        .firstWhere((product) => product.id == pId);
    return Scaffold(
      appBar: AppBar(
        title: Text(clickedProduct.title),
      ),
    );
  }
}
