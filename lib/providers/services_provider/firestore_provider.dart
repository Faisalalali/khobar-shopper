import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khobar_shopper/exports/models.dart' show Customer, Product;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// To access [FirestoreProvider].
final firestoreProvider =
    Provider<FirestoreProvider>((ref) => FirestoreProvider());

class FirestoreProvider {
  late FirebaseFirestore _firestore;

  // Collections
  static const String customer_collection = 'customer';
  static const String product_collection = 'item';

  FirestoreProvider() {
    _firestore = FirebaseFirestore.instance;
  }

  //**************************[Customer Operations]************************** */
  /// Store the data for the new user in Firestore.
  Future<void> createCustomer(
    String uid,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(customer_collection).doc(uid).set(data);
    } catch (e) {
      throw e;
    }
  }

  /// Return [Customer] object. If it doesn't exist, it will return null.
  Future<Customer?> getCustomer(
    String uid,
  ) async {
    try {
      Customer? customer;
      await _firestore
          .collection(customer_collection)
          .doc(uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          customer = Customer.fromJson(doc.data()!);
        } else {
          customer = null;
        }
      });
      return customer;
    } catch (e) {
      throw e;
    }
  }

  /// Update [Customer] data.
  Future<void> updateCustomer(
    String uid,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(customer_collection).doc(uid).update(data);
    } catch (e) {
      throw e;
    }
  }

  /// Delete [Customer] data.
  Future<void> deleteCustomer(String uid) async {
    try {
      await _firestore.collection(customer_collection).doc(uid).delete();
    } catch (e) {
      throw e;
    }
  }

  //**************************[Product Operations]*************************** */
  /// Store the data for the new product in Firestore.
  Future<void> createProduct(
    String uid,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(product_collection).doc(uid).set(data);
    } catch (e) {
      throw e;
    }
  }

  /// Return [Product] object. If it doesn't exist, it will return null.
  Future<Product?> getProduct(
    String uid,
  ) async {
    try {
      Product? product;
      await _firestore
          .collection(product_collection)
          .doc(uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          product = Product.fromJson(doc.data()!);
        } else {
          product = null;
        }
      });
      return product;
    } catch (e) {
      throw e;
    }
  }

  /// Return [List<Product>] object.
  Future<List<Product>> getProducts() async {
    try {
      List<Product> products = [];
      await _firestore.collection(product_collection).get().then((snapshot) {
        snapshot.docs.forEach((doc) {
          products.add(Product.fromJson(doc.data()));
        });
      });
      return products;
    } catch (e) {
      throw e;
    }
  }

  /// Update [Product] data.
  Future<void> updateProduct(
    String uid,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(product_collection).doc(uid).update(data);
    } catch (e) {
      throw e;
    }
  }

  /// Delete [Product] data.
  Future<void> deleteProduct(String uid) async {
    try {
      await _firestore.collection(product_collection).doc(uid).delete();
    } catch (e) {
      throw e;
    }
  }
}
