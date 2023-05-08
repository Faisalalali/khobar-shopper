import 'package:khobar_shopper/exports/components.dart' show SplashScreen;
import 'package:khobar_shopper/exports/models.dart' show Customer, Product;
import 'package:khobar_shopper/exports/providers.dart'
    show authProvider, firestoreProvider, userProvider;
import 'package:khobar_shopper/exports/screens.dart'
    show BottomNavigation, LoginScreen;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fetching user data
final userDataFuture = FutureProvider.autoDispose<dynamic>((ref) async {
  // Initialing provider
  final auth = ref.watch(authProvider);
  final firestore = ref.watch(firestoreProvider);

  // Check if the user is [Customer]
  Customer? customer = await firestore.getCustomer(auth.uid);
  if (customer != null) {
    auth.setObj(customer);
    return customer;
  }

  // If the user neither [Host] nor [Business] user, then return null
  auth.setObj(null);
  return null;
});

class FirestoreBuilder extends ConsumerStatefulWidget {
  @override
  ConsumerState<FirestoreBuilder> createState() => _FirestoreBuilderState();
}

class _FirestoreBuilderState extends ConsumerState<FirestoreBuilder> {
  @override
  Widget build(BuildContext context) {
    //Initializing providers
    final userAsync = ref.watch(userDataFuture);
    final user = ref.read(userProvider);

    return userAsync.when(
      data: (userObj) {
        if (userObj != null) {
          user.setCustomerObject(userObj);
          return BottomNavigation();
        }
        return LoginScreen();
      },
      error: (error, stackTrace) {
        return SplashScreen(
          content: 'Something went wrong!',
          loadingIndicator: false,
        );
      },
      loading: () {
        return SplashScreen();
      },
    );
  }
}
