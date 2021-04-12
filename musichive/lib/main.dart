import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/presentation/const.dart';
import 'view/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MUSIC HIVE',
      theme: ThemeData(
        primaryColor: themeColor,
      ),
      home: LoginScreen(title: 'MUSIC HIVE'),
      debugShowCheckedModeBanner: false,
    );
  }
}
