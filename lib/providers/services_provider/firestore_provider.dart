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

  FirestoreProvider() {
    _firestore = FirebaseFirestore.instance;
  }

  //**************************[Customer Operations]****************************************** */
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
}
