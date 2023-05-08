class Product {
  final String name;
  final String image;
  final double price;
  final int quantity;
  final String? description;
  final double? rating;
  final String? category;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    this.description,
    this.rating,
    this.category,
  });

  Product.fromJson(Map<String, dynamic> data)
      : this(
          name: data['name'],
          image: data['image'],
          price: data['price'],
          quantity: data['quantity'],
          description: data['description'],
          rating: data['rating'],
          category: data['category'],
        );

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'price': price,
        'quantity': quantity,
        'description': description,
        'rating': rating,
        'category': category,
      };
}
