import 'package:khobar_shopper/components/text_fields/name_text_field.dart';
import 'package:khobar_shopper/exports/components.dart'
    show
        BuildingTextField,
        CityDropDown,
        CustomFlatButton,
        LoadingIndicator,
        PhoneTextField,
        StreetTextField,
        ZipCodeTextField;
import 'package:khobar_shopper/exports/models.dart' show Customer;
import 'package:khobar_shopper/exports/providers.dart'
    show
        userProvider,
        authProvider,
        firestoreProvider,
        connectionResultProvider;
import 'package:khobar_shopper/routes/routes.dart';
import 'package:khobar_shopper/exports/utils.dart' show SnackBarError;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  // Keys
  final GlobalKey<FormState> _formKey = GlobalKey();

  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  // Values
  bool _submitted = false;
  bool _isLoading = false;
  var cityCurrentValue;

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

  Future<void> registerAndNavigate() async {
    try {
      // Initialize providers
      final user = ref.read(userProvider);
      final auth = ref.read(authProvider);
      final firestore = ref.read(firestoreProvider);

      // Create [Customer] object
      Customer customer = Customer(
        uid: auth.uid,
        email: user.email,
        name: nameController.text.trim(),
        phoneNumber: '+966${phoneController.text.trim()}',
        address: {
          'street': streetController.text.trim(),
          'zipCode': int.parse(zipCodeController.text.trim()),
          'building': buildingController.text.trim(),
        },
      );

      user.setCustomerObject(customer);
      auth.setObj(customer);

      // Store data
      await firestore.createCustomer(auth.uid, customer.toJson());

      showLoadingIndicator(false);
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.bottom_navigation, (route) => false);
    } catch (e) {
      throw e;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    buildingController.dispose();
    streetController.dispose();
    zipCodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connected = ref.watch(connectionResultProvider);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Personal Information',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        NameTextField(
                                          controller: nameController,
                                          submitted: _submitted,
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          'Phone Number',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        PhoneTextField(
                                          controller: phoneController,
                                          submitted: _submitted,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Personal Address',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'City',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        CityDropDown(
                                          submitted: _submitted,
                                          value: cityCurrentValue,
                                          onChanged: (value) {
                                            setState(() {
                                              cityCurrentValue = value;
                                            });
                                          },
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          'Building',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        BuildingTextField(
                                          controller: buildingController,
                                          submitted: _submitted,
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          'Street',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        StreetTextField(
                                          controller: streetController,
                                          submitted: _submitted,
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          'Zip Code',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        ZipCodeTextField(
                                          controller: zipCodeController,
                                          submitted: _submitted,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          CustomFlatButton(
                            label: 'Submit',
                            onPressed: () async {
                              if (connected) {
                                if (!_isLoading) {
                                  if (onSubmit()) {
                                    try {
                                      showLoadingIndicator(true);
                                      await registerAndNavigate();
                                    } catch (e) {
                                      showLoadingIndicator(false);
                                      context.showSnackBarError(e.toString());
                                    }
                                  }
                                }
                              } else {
                                context.showSnackBarError(
                                    'No connection to internet');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                LoadingIndicator(isLoading: _isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
