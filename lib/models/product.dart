class Product {
  final String name;
  final double price;
  final int quantity;
  final String? image;
  final String? description;
  final double? rating;
  final String? category;

  Product({
    required this.name,
    required this.price,
    required this.quantity,
    this.image,
    this.description,
    this.rating,
    this.category,
  });

  Product.fromJson(Map<String, dynamic> data)
      : this(
          name: data['name'],
          price: data['price'],
          quantity: data['quantity'],
          image: data['image'],
          description: data['description'],
          rating: data['rating'],
          category: data['category'],
        );

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'quantity': quantity,
        'image': image,
        'description': description,
        'rating': rating,
        'category': category,
      };

  get getPrice => price;
  get getQuantity => quantity;
  get getName => name;
}
