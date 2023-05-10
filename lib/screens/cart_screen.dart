import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khobar_shopper/exports/providers.dart'
    show
        ConnectivityStatus,
        authProvider,
        authStateChangeProvider,
        connectionResultProvider,
        connectionStream;
import 'package:khobar_shopper/exports/providers.dart'
    show
        authProvider,
        connectionResultProvider,
        firestoreProvider,
        userProvider;
import 'package:khobar_shopper/screens/product_view2.dart';

import '../utils/app_utils/app_color.dart';

// Providers
final cartProvider = StreamProvider<Map<String, int>>((ref) {
  final cartRef = FirebaseFirestore.instance.collection('cart');

  return cartRef.doc(ref.read(authProvider).uid).snapshots().map((snapshot) {
    if (!snapshot.exists || snapshot.data() == null) {
      cartRef.doc(ref.read(authProvider).uid).set({}); // Change to an empty map
      return {};
    }

    return snapshot
        .data()!
        .cast<String, int>(); // Cast the data to a Map<String, int>
  });
});

class CartScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  late final cartRef = FirebaseFirestore.instance.collection('cart');

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    debugPrint('cart: $cart');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: cart.when(
          data: (cart) {
            final cartItems = cart.entries.toList();
            return GridView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return createCard(
                  item.key,
                  item.value.toDouble(),
                  null,
                  null,
                  null,
                  null,
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
        ),
        bottomSheet: ElevatedButton(
          onPressed: () {
            cartRef.doc(ref.read(authProvider).uid).delete();
          },
          child: const Text(
            'Pay',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: AppColor.lightBlue,
            minimumSize: const Size.fromHeight(60),
          ),
        ));
  }

  ElevatedButton createCard(String name, double quantity, String? image,
      String? description, double? rating, List<dynamic>? category) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              child: ProductView2(
                name: name,
                price: quantity,
                image: base64.decode(image ?? ''),
                description: description,
                rating: rating,
                category: category,
              ),
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: Colors.black,
        elevation: 5,
        surfaceTintColor: Colors.white,
      ),
      child: Stack(
        children: [
          // Title and description
          Positioned(
            left: 4,
            right: 4,
            top: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 4),
                Text(
                  description ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          // Price and rating
          Center(
            child: Positioned(
              bottom: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.remove,
                    color: AppColor.darkBlue,
                    size: 30,
                  ),
                  Text(
                    quantity.toString().split('.')[0],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Icon(
                    Icons.add,
                    color: AppColor.darkBlue,
                    size: 30,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
