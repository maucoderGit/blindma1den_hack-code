import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/firebase_options.dart';
import 'package:flutter_apps/login.dart';
import 'package:flutter_apps/screens/area.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {

    initFirebase() async {
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    initFirebase();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      initialRoute: "/home",
      routes: {
        "/home": (context) => const AreaScreen(),
        "/login": (context) => const LoginScreen(),
      },
    );
  }
}