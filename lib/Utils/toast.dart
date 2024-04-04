import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';

void successToast(msg, context) {
  CherryToast.success(
    title: Text(msg, style: const TextStyle(color: Colors.black)),
    animationDuration: const Duration(milliseconds: 500),
  ).show(context);
}

void errorToast(msg, context) {
  CherryToast.error(
    title: Text(msg),
    animationDuration: const Duration(milliseconds: 500),
  ).show(context);
}
