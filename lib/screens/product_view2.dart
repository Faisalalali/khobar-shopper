import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:khobar_shopper/exports/models.dart' show Customer;
import 'package:khobar_shopper/exports/providers.dart'
    show
        authProvider,
        connectionResultProvider,
        firestoreProvider,
        userProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khobar_shopper/exports/utils.dart';

// Providers
final cartProvider = StreamProvider<Map<String, int>>((ref) {
  // Get a reference to the Firestore collection
  CollectionReference cartRef = FirebaseFirestore.instance.collection('cart');

  // Get the document
  return cartRef.doc(ref.read(authProvider).uid).snapshots().map((snapshot) {
    // If the document doesn't exist or there is no data in it, create an empty
    // map and set it to the document in Firestore
    if (!snapshot.exists || snapshot.data() == null) {
      cartRef.doc(ref.read(authProvider).uid).set({});
      return {};
    }

    // if the document exists and there is data in it, return the data
    return snapshot.data()! as Map<String, int>;
  });
});

class ProductView2 extends ConsumerStatefulWidget {
  const ProductView2({
    Key? key,
    required this.name,
    required this.price,
    required this.image,
    this.description,
    this.rating,
    this.category,
  }) : super(key: key);

  final String name;
  final double price;
  final Uint8List? image;
  final String? description;
  final double? rating;
  final List<dynamic>? category;

  @override
  ConsumerState<ProductView2> createState() => _ProductViewState();
}

class _ProductViewState extends ConsumerState<ProductView2> {
  int amount = 1;

  late final user;
  late final auth;
  late final firestore;
  Map<String, int> cart = {};

  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider);
    auth = ref.read(authProvider);
    firestore = ref.read(firestoreProvider);
    debugPrint(auth.uid);

    debugPrint(cartProvider.toString());
  }

  @override
  Widget build(BuildContext context) {
    final cartRef = ref.watch(cartProvider);
    return SizedBox(
      height: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 10),
          Text(
            widget.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.description ?? '',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.price.toString() + ' SAR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      Text(
                        widget.rating.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.blueGrey,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // amount
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (amount > 1) amount--;
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text(
                    amount.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (amount < 10) amount++;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add to cart
                      // Get the current cart
                      cartRef.when(
                        data: (data) => cart = data,
                        loading: () => cart = {},
                        error: (error, stackTrace) => cart = {},
                      );

                      // Add the product to the cart
                      if (cart.containsKey(widget.name)) {
                        cart[widget.name] = cart[widget.name]! + amount;
                      } else {
                        cart[widget.name] = amount;
                      }

                      // Update the cart in Firestore
                      FirebaseFirestore.instance
                          .collection('cart')
                          .doc(auth.uid)
                          .set(cart, SetOptions(merge: true));

                      // Show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added to cart'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
