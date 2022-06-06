import 'package:flutter/material.dart';
import 'package:taletime/utils/constants.dart';

Widget inputText({label, icon, obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
            prefixIcon: icon,
            prefixIconColor: kPrimaryColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey))),
      ),
      const SizedBox(
        height: 15,
      )
    ],
  );
}
