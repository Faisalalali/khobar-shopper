import 'package:khobar_shopper/exports/utils.dart' show AppColor;
import 'package:flutter/material.dart';

extension SnackBarError on BuildContext {
  /// A snackbar error is shown, and if the the [message] is found in the ar.json or en.json files.
  showSnackBarError(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: Theme.of(this)
                .textTheme
                .titleSmall!
                .copyWith(color: Colors.white),
          ),
          backgroundColor: AppColor.red,
          duration: Duration(seconds: 5),
        ),
      );
  }
}
