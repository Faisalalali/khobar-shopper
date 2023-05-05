import 'package:khobar_shopper/exports/utils.dart' show AppColor, AppConst;
import 'package:flutter/material.dart';

class CityDropDown extends StatelessWidget {
  final String? value;
  final Function(String?) onChanged;
  final bool submitted;

  CityDropDown({
    required this.value,
    required this.submitted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      hint: Text(
        'Select',
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(height: 1.2, color: AppColor.grey),
      ),
      icon: Icon(
        Icons.expand_more_outlined,
        color: AppColor.darkBlue,
      ),
      style: Theme.of(context).textTheme.bodyLarge,
      elevation: 16,
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Field is required';
        } else {
          return null;
        }
      },
      autovalidateMode: submitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      dropdownColor: Colors.white,
      decoration: InputDecoration(
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
      ),
      items: AppConst.saudiArabiaCities.map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: SizedBox(
              child: Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(height: 1.2),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
