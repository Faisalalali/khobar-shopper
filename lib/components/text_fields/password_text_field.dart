import 'package:flutter/material.dart';
import 'package:khobar_shopper/exports/utils.dart' show AppColor, AppReg;

/// Textfield for Password
class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool submitted;
  final TextInputAction action;
  final bool isConfirmPassword;

  PasswordTextField({
    required this.controller,
    required this.submitted,
    required this.action,
    required this.isConfirmPassword,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  // Values
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      textInputAction: widget.action,
      textDirection: TextDirection.ltr,
      autovalidateMode: widget.submitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 1.2),
      obscuringCharacter: '*',
      maxLength: widget.isConfirmPassword ? 10 : null,
      obscureText: obscureText,
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
        hintText: 'Password',
        hintStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(height: 1.2, color: AppColor.grey),
        hintTextDirection: TextDirection.ltr,
        errorStyle: TextStyle(fontSize: 11, overflow: TextOverflow.ellipsis),
        errorMaxLines: 3,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          child: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            size: 22,
            color: AppColor.darkBlue,
          ),
        ),
      ),
      validator: (String? text) {
        if (text == null || text.isEmpty) {
          return 'Field is required';
        } else if (widget.isConfirmPassword &&
            !AppReg.passwordRegex.hasMatch(text)) {
          return 'Password must be 10 characters long with at least one uppercase letter, one lowercase letter, and one special character';
        }
        return null;
      },
    );
  }
}
