import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/firebase_options.dart';
import 'package:flutter_apps/login.dart';
import 'package:flutter_apps/screens/area.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );


  final prefs = await SharedPreferences.getInstance();
  final user = prefs.get("user");

  print("user $user");
    
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
      theme: ThemeData.light(useMaterial3: true),
      initialRoute: isLogged ? "/home": "/login",
      routes: {
        "/home": (context) => const AreaScreen(),
        "/login": (context) => const LoginScreen(),
      },

    );
  }
}


// class MyApp extends StatefulWidget {
//   const MyApp({ super.key });

//   @override
//   // ignore: library_private_types_in_public_api
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//     bool _isLogged = false;




//    @override
//   void initState() {
//     super.initState();
//     userLogged();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("_isLogged $_isLogged");
//         return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light(useMaterial3: true),
//       initialRoute: _isLogged ? "/home" : "/login",
//       routes: {
//         "/home": (context) => const AreaScreen(),
//         "/login": (context) => const LoginScreen(),
//       },
      
//     );
//   }
// }

