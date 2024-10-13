import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/firebase_options.dart';
import 'package:flutter_apps/screens/areac.dart';
import 'package:flutter_apps/screens/login.dart';
import 'package:flutter_apps/screens/area.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

  final prefs = await SharedPreferences.getInstance();
  final user = prefs.get("user");
  final isLogged = user != null;
  runApp(MyApp(
    isLogged: isLogged,
  ));
}


class MyApp extends StatelessWidget {
    final bool isLogged;
  const MyApp({super.key, required this.isLogged});



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      initialRoute: isLogged ? "/home": "/login",
      routes: {
        "/home": (context) => const AreaCScreen(),
        "/login": (context) => const LoginScreen(),
      },

    );
  }
}