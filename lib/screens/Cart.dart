import 'package:ecommerce_app/providers/ordersProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/providers/cartProvider.dart' show CartProvider;
import '../widgets/CartItem.dart';

class Cart extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "₹ ${cart.getTotalAmount.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.getItemCount,
              itemBuilder: (ctx, index) {
                return CartItem(
                  cart.getCartItem.values.toList()[index].id,
                  cart.getCartItem.keys.toList()[index],
                  cart.getCartItem.values.toList()[index].title,
                  cart.getCartItem.values.toList()[index].price,
                  cart.getCartItem.values.toList()[index].quantity,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final CartProvider cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.getTotalAmount <= 0.0 || isLoading)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<OrdersProvider>(context, listen: false)
                  .addOrder(
                widget.cart.getCartItem.values.toList(),
                widget.cart.getTotalAmount,
              );
              setState(() {
                isLoading = false;
              });
              widget.cart.clear();
            },
      child: isLoading
          ? CircularProgressIndicator()
          : Text(
              "ORDER NOW",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
    );
  }
}
