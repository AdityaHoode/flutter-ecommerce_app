import '../widgets/ProductsGrid.dart';
import 'package:flutter/material.dart';

class ProductsOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Shop"),
        ),
        body: ProductsGrid(),
      ),
    );
  }
}
