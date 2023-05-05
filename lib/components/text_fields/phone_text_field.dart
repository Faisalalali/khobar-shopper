import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khobar_shopper/exports/utils.dart' show AppColor, AppReg;

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool submitted;
  const PhoneTextField({
    required this.controller,
    required this.submitted,
  });

  /// Validating the phone number in the correct format
  bool validatephoneNumber() {
    String phone = '+966' + controller.text.trim();
    return AppReg.phoneNumber.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 1.2),
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.allow(AppReg.numbersRegex),
      ],
      autofillHints: [
        AutofillHints.telephoneNumber,
      ],
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.done,
      maxLength: 9,
      autovalidateMode: submitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        focusColor: AppColor.darkBlue,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(color: AppColor.darkBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(color: AppColor.darkBlue),
        ),
        counterText: '',
        hintText: '5XXXXXXXX',
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(height: 1.2, color: AppColor.grey),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 8,
          ),
          child: Text(
            '+966',
            style:
                Theme.of(context).textTheme.titleMedium!.copyWith(height: 1.2),
          ),
        ),
      ),
      validator: (String? text) {
        if (text == null || text.isEmpty) {
          return 'Field is required';
        } else if (controller.text.length < 9) {
          return 'Please enter only 9 digits';
        } else if (!AppReg.numbersRegex.hasMatch(controller.text)) {
          return 'Numbers only';
        } else if (!validatephoneNumber()) {
          return 'Phone number is not valid';
        }
        return null;
      },
      onChanged: (value) {
        if (value.length == 9) {
          FocusScope.of(context).unfocus();
        }
      },
    );
  }
}
