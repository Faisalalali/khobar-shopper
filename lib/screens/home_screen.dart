import 'package:flutter/material.dart';
import 'package:khobar_shopper/exports/utils.dart' show AppColor;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Methods
  ElevatedButton getCard() {
    return ElevatedButton(
      onPressed: () {},
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
            child: Placeholder(color: Colors.grey),
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
                  'Title',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 4),
                Text(
                  'Description',
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
                  '99.99',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'SAR',
                  style: Theme.of(context).textTheme.titleMedium,
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
                  '4.5',
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
        child: GridView(
          clipBehavior: Clip.none,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: [
            getCard(),
            getCard(),
            getCard(),
            getCard(),
            getCard(),
            getCard(),
            getCard(),
            getCard(),
            getCard(),
          ],
        ),
      ),
    );
  }
}
