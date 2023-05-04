import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {},
          ),
          Text("   ") // This is a temporary fix to add space between the icons, until I find a better way.
        ],
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        iconTheme: const IconThemeData(color: Colors.blueGrey, size: 30),
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

ElevatedButton getCard() {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
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
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                'Description',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
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
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                'SAR',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Positioned(
          right: 4,
          bottom: 4,
          child: Row(
            children: [
              Icon(Icons.star, size: 16, color: Colors.blueGrey),
              SizedBox(width: 4),
              Text(
                '4.5',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
