import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showAppAlert(
  BuildContext context, {
  required String title,
  required String description,
  required String type,
  required int duration,
}) {
  ToastificationType toastType;

  switch (type.toLowerCase()) {
    case 'success':
      toastType = ToastificationType.success;
      break;
    case 'info':
      toastType = ToastificationType.info;
      break;
    case 'warning':
      toastType = ToastificationType.warning;
      break;
    case 'error':
    default:
      toastType = ToastificationType.error;
      break;
  }

  toastification.show(
    context: context,
    title: Text(title),
    autoCloseDuration: Duration(seconds: duration),
    animationDuration: const Duration(milliseconds: 300),
    style: ToastificationStyle.minimal,
    type: toastType,
    description: Text(description, style: TextStyle(color: Colors.black)),
    alignment: Alignment.bottomCenter,
  );
}
