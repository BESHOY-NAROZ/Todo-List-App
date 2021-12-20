import 'package:flutter/material.dart';

class DefaultTextForm extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  Icon icon;
  Function onTap;
  Function onChanged;
  FormFieldValidator<String> validator;
  TextInputType keyboardType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTap: onTap,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        icon: icon,
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
    );
  }

  DefaultTextForm(
      {this.controller,
      this.hintText,
      this.keyboardType,
      this.icon,
      this.onTap,
      this.onChanged,
      this.validator});
}
