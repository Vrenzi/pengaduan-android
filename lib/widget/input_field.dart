import 'package:pengaduan/helper/constant.dart';
import 'package:flutter/material.dart';

InputField({
  // required double width,
  required TextEditingController controller,
  required String hintText,
  bool isObscure = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
          ),
          obscureText: isObscure,
        ),
      ),
    ),
  );
}
