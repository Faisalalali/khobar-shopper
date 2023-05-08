import 'product.dart';

// Cart is a singleton class
// is contains a map of products and their quantity

class Cart {
  static final Cart _cart = Cart._internal();
  factory Cart() {
    return _cart;
  }
  Cart._internal();

  final Map<Product, int> items = {};

  Map<Product, int> _products = {
    for (var i = 0; i < 10; i++)
      Product(
        name: 'Product $i',
        image: 'assets/images/product.png',
        price: 10.0,
        quantity: 10,
        description: 'Product $i description',
        rating: 4.5,
        category: 'Category $i',
      ): 1,
  };

  Map<Product, int> get products => _products;

  void addProduct(Product product) {
    if (_products.containsKey(product)) {
      _products[product] = _products[product]! + 1;
    } else {
      _products[product] = 1;
    }
  }

  void removeProduct(Product product) {
    if (_products.containsKey(product)) {
      if (_products[product] == 1) {
        _products.remove(product);
      } else {
        _products[product] = _products[product]! - 1;
      }
    }
  }

  void remove(Product product) {
    _products.remove(product);
  }
}
