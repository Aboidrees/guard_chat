import 'package:flutter/material.dart';
import 'package:guard_chat/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // // await FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.playIntegrity);

  // await FirebaseAppCheck.instance.activate();
  runApp(const GuardChat());
}
