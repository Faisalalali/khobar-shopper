import 'package:flutter/material.dart';
import 'package:khobar_shopper/exports/utils.dart' show AppColor;

/// Textfield for event title
class StreetTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool submitted;

  StreetTextField({
    required this.controller,
    required this.submitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      textDirection: TextDirection.ltr,
      autovalidateMode: submitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 1.2),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
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
        labelStyle: Theme.of(context).textTheme.bodySmall,
        hintText: 'Academic Belt Road',
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(height: 1.2, color: AppColor.grey),
        hintTextDirection: TextDirection.ltr,
        errorStyle: TextStyle(fontSize: 11),
      ),
      validator: (String? text) {
        if (text == null || text.isEmpty) {
          return 'Field is required';
        }
        return null;
      },
    );
  }
}
