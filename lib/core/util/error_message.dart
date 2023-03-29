import 'package:flutter/material.dart';

errorMessage(context, {msg}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  debugPrint(msg);
}
