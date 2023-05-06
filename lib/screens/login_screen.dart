import 'package:flutter/gestures.dart';
import 'package:khobar_shopper/exports/models.dart' show Customer;
import 'package:khobar_shopper/exports/providers.dart'
    show
        authProvider,
        connectionResultProvider,
        firestoreProvider,
        userProvider;
import 'package:khobar_shopper/routes/routes.dart';
import 'package:khobar_shopper/exports/components.dart'
    show CustomFlatButton, EmailTextField, LoadingIndicator, PasswordTextField;
import 'package:khobar_shopper/exports/utils.dart' show AppColor, SnackBarError;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khobar_shopper/exports/utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Keys
  final GlobalKey<FormState> _formKey = new GlobalKey();

  // Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Values
  bool _submitted = false;
  bool _isLoading = false;

  // Methods
  /// This method is to check whether the textfield is filled with required data
  bool onSubmit() {
    setState(() {
      _submitted = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      return true;
    }
    return false;
  }

  /// To show the loading indicator
  void showLoadingIndicator(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  /// Login to the system, retrieve data, then navigate
  Future<void> loginAndNavigate() async {
    try {
      // Initialize providers
      final user = ref.read(userProvider);
      final auth = ref.read(authProvider);
      final firestore = ref.read(firestoreProvider);

      // Login
      await auth.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Check if he is a [Host] user
      Customer? customer = await firestore.getCustomer(auth.uid);
      if (customer != null) {
        showLoadingIndicator(false);

        user.setCustomerObject(customer);
        auth.setObj(customer);

        // Navigate
        Navigator.pushReplacementNamed(
          context,
          Routes.bottom_navigation,
        );
      }

      showLoadingIndicator(false);

      // If user not found, will go to the registration screen
      user.setEmail(emailController.text.trim());
      auth.setObj(null);

      // Navigate
      Navigator.pushReplacementNamed(
        context,
        Routes.registration,
      );
    } catch (e) {
      showLoadingIndicator(false);
      throw e;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connected = ref.watch(connectionResultProvider);
    final user = ref.read(userProvider);

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TODO: ADD LOGO
                SizedBox(height: 200),
                Form(
                  key: _formKey,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 10),
                          EmailTextField(
                            controller: emailController,
                            submitted: _submitted,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Password',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 10),
                          PasswordTextField(
                            controller: passwordController,
                            submitted: _submitted,
                            isConfirmPassword: false,
                            action: TextInputAction.done,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Don’t have an account?',
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                                  TextSpan(
                                    text: ' Register now',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          color: AppColor.darkBlue,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w700,
                                        ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        Navigator.pushNamed(
                                            context, Routes.signup);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                CustomFlatButton(
                  label: 'Next',
                  onPressed: () async {
                    if (connected) {
                      context.showSnackBarError('No connection to internet');
                      return;
                    }
                    if (_isLoading || !onSubmit()) {
                      return;
                    }
                    try {
                      showLoadingIndicator(true);
                      await loginAndNavigate();
                    } catch (e) {
                      if (e.toString() == 'Email not verified') {
                        user.setEmail(emailController.text.trim());
                        Navigator.pushNamed(context, Routes.verification);
                      } else if (mounted) {
                        context.showSnackBarError(e.toString());
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          LoadingIndicator(isLoading: _isLoading),
        ],
      ),
    );
  }
}
