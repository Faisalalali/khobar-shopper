import 'package:khobar_shopper/exports/models.dart' show Product;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// To access [ProductProvider]
final productProvider = Provider<ProductProvider>((ref) {
  return ProductProvider();
});

class ProductProvider {
  Product? _product;

  void setProductObject(Product product) {
    _product = product;
  }

  Product get product => _product!;
}
