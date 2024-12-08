import 'package:firebase_core/firebase_core.dart';
import 'package:fn_prj/pages/firebase_options.dart';
import 'package:fn_prj/pages/login_page.dart';
import 'package:fn_prj/pages/register_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    home: LoginPage(),
  ));
}
