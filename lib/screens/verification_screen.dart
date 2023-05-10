import 'dart:async';

import 'package:khobar_shopper/exports/components.dart' show LoadingIndicator;
import 'package:khobar_shopper/exports/models.dart' show Customer;
import 'package:khobar_shopper/exports/providers.dart'
    show authProvider, firestoreProvider, userProvider;
import 'package:khobar_shopper/routes/routes.dart';
import 'package:khobar_shopper/exports/utils.dart' show AppColor, SnackBarError;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  // Values
  static const maxSeconds = 60;
  int _seconds = maxSeconds;
  Timer? timer;
  bool _isLoading = false;
  bool isVerified = false;
  // Methods
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  /// Will start during building the ui
  Future<void> startTimer() async {
    final auth = ref.read(authProvider);
    while (_seconds > 0) {
      isVerified = await auth.checkEmailVerification();
      if (mounted) {
        setState(() {});
      }
      if (isVerified) {
        await getUserDataAndNavigate();
        break;
      }
      await Future.delayed(Duration(seconds: 1));
      _seconds--;
    }
    if (!isVerified) {
      // If the time finishes without verification
      timeOut();
    }
  }

  void timeOut() {
    context.showSnackBarError('Your request timed out, please try again.');
    Navigator.pop(context);
  }

  /// To show the loading indicator
  void showLoadingIndicator(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  Future<void> getUserDataAndNavigate() async {
    try {
      showLoadingIndicator(true);
      // Initialize providers
      final user = ref.read(userProvider);
      final auth = ref.read(authProvider);
      final firestore = ref.read(firestoreProvider);

      // Check if this user exists
      Customer? customer = await firestore.getCustomer(auth.uid);
      if (customer != null) {
        user.setCustomerObject(customer);

        showLoadingIndicator(false);
        // Navigate
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.bottom_navigation,
          (routes) => false,
        );
        return;
      }
      showLoadingIndicator(false);
      
      // If it doesn't exists then we need to register the user.
      Navigator.pushNamed(context, Routes.registration);
      return;
    } catch (e) {
      showLoadingIndicator(false);
      context.showSnackBarError(e.toString());
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColor.darkBlue,
            size: 28,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          splashColor: AppColor.darkBlue.withOpacity(0.2),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Column(
                    children: [
                      Text(
                        'Verification Email',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 7.5),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'We have sent a verification link to',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(),
                          children: [
                            TextSpan(
                              text: '\n${user.email}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    height: 1.5,
                                    color: AppColor.darkBlue,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  Navigator.popAndPushNamed(
                                      context, Routes.login);
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          LoadingIndicator(isLoading: _isLoading)
        ],
      ),
    );
  }
}
