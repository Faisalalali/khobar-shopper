import 'package:flutter/material.dart';
import 'package:khobar_shopper/exports/utils.dart' show AppColor;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khobar_shopper/exports/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'dart:convert';
import 'product_view.dart';

// Providers
final productsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  // Get a reference to the Firestore collection
  CollectionReference productsRef =
      FirebaseFirestore.instance.collection('item');

  // Return a stream of the documents in the collection
  return productsRef.snapshots().map((querySnapshot) => querySnapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList());
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // _firestore = context.read(firestoreProvider);
  }

  // Methods
  ElevatedButton createCard(String name, double price, String? image,
      String? description, double? rating, List<dynamic>? category) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              child: ProductView(
                name: name,
                price: price,
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
        maximumSize: const Size(150, 180),
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
          // Image
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            bottom: 80,
            child: image != null
                ? Image.memory(
                    base64.decode(image),
                    fit: BoxFit.contain,
                  )
                : Placeholder(
                    color: Colors.grey,
                  ),
          ),
          // Title and description
          Positioned(
            left: 4,
            right: 4,
            top: 110,
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
          Positioned(
            left: 4,
            bottom: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'SAR',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          Positioned(
            right: 4,
            bottom: 4,
            child: Row(
              children: [
                Icon(Icons.star, size: 16, color: AppColor.darkBlue),
                SizedBox(width: 4),
                Text(
                  rating.toString() ?? '-',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        iconTheme: IconThemeData(color: AppColor.darkBlue, size: 30),
        leadingWidth: 75,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer(
          builder: (context, watch, child) {
            AsyncValue<List<Map<String, dynamic>>> products =
                ref.watch(productsProvider);

            // Handle loading and error states
            return products.when(
              data: (data) {
                debugPrint('data: $data');
                return GridView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> product = data[index];

                    // Display the product in a ListTile
                    return createCard(
                      product['name'],
                      product['price'],
                      product['image'],
                      product['description'] ?? null,
                      product['rating'] ?? null,
                      product['category'] ?? null,
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                );
              },
              loading: () => CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            );
          },
        ),
      ),
    );
  }
}
