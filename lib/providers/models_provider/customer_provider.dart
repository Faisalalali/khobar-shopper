import 'package:khobar_shopper/exports/models.dart' show Customer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// To access [CustomerProvider]
final userProvider = Provider<CustomerProvider>((ref) {
  return CustomerProvider();
});

class CustomerProvider {
  Customer? _customer;

  String? _email;

  void setCustomerObject(Customer customer) {
    _customer = customer;
  }

  void setEmail(String email) {
    _email = email;
  }

  Customer get customer => _customer!;
  String get email => _email!;
}
