import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khobar_shopper/exports/utils.dart' show AppColor, AppReg;

class ZipCodeTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool submitted;

  ZipCodeTextField({
    required this.controller,
    required this.submitted,
  });

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
        hintText: '12345',
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(height: 1.2, color: AppColor.grey),
        counterText: '',
      ),
      validator: (String? text) {
        if (text == null || text.isEmpty) {
          return 'Field is required';
        } else if (!AppReg.numbersRegex.hasMatch(controller.text)) {
          return 'Numbers only';
        }
        return null;
      },
    );
  }
}
