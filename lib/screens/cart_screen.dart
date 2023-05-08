import 'package:flutter/material.dart';
import 'package:khobar_shopper/models/cart.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart cart = Cart();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // cart screen showing the products added to cart
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cart.items[index].name),
            subtitle: Text(cart.items[index].price.toString()),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  cart.remove(cart.items[index]);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
