import 'package:khobar_shopper/exports/providers.dart'
    show authProvider, connectionResultProvider, userProvider;
import 'package:khobar_shopper/routes/routes.dart';
import 'package:khobar_shopper/exports/components.dart'
    show CustomFlatButton, EmailTextField, LoadingIndicator, PasswordTextField;
import 'package:khobar_shopper/exports/utils.dart' show AppColor, SnackBarError;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  // Keys
  final GlobalKey<FormState> _formKey = new GlobalKey();

  // Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
      if (passwordController.text == confirmPasswordController.text) {
        return true;
      } else {
        context.showSnackBarError('The two passwords aren\'t the same');
        return false;
      }
    }
    return false;
  }

  /// To show the loading indicator
  void showLoadingIndicator(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authProvider);
    final connected = ref.watch(connectionResultProvider);
    final user = ref.read(userProvider);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //TODO ADD LOO
                      SizedBox(height: 150),
                      Form(
                        key: _formKey,
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                SizedBox(height: 10),
                                EmailTextField(
                                  controller: emailController,
                                  submitted: _submitted,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Password',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                SizedBox(height: 10),
                                PasswordTextField(
                                  controller: passwordController,
                                  submitted: _submitted,
                                  isConfirmPassword: true,
                                  action: TextInputAction.next,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Confirm Password',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                SizedBox(height: 10),
                                PasswordTextField(
                                  controller: confirmPasswordController,
                                  submitted: _submitted,
                                  action: TextInputAction.done,
                                  isConfirmPassword: true,
                                ),
                                SizedBox(height: 15),
                                Align(
                                  alignment: Alignment.center,
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: 'Already have an account?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(),
                                      children: [
                                        TextSpan(
                                          text: ' Login',
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
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                Routes.login,
                                                (routes) => false,
                                              );
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
                            if (!_isLoading) {
                              if (onSubmit()) {
                                try {
                                  showLoadingIndicator(true);
                                  user.setEmail(emailController.text.trim());
                                  await auth.registerWithEmailAndPassword(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                                  showLoadingIndicator(false);
                                  Navigator.pushNamed(
                                      context, Routes.verification);
                                } catch (e) {
                                  showLoadingIndicator(false);
                                  context.showSnackBarError(e.toString());
                                }
                              }
                            }
                          } else {
                            context
                                .showSnackBarError('No connection to internet');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          LoadingIndicator(isLoading: _isLoading),
        ],
      ),
    );
  }
}
