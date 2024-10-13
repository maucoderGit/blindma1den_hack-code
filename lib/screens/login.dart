import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<UserCredential> signInWithGoogle(context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final dataUser =
          await FirebaseAuth.instance.signInWithCredential(credential);
      FirebaseFirestore.instance
          .collection('users')
          .doc(dataUser.user?.email)
          .set({
        "email": dataUser.user?.email,
        "name": dataUser.user?.displayName,
        "photo": dataUser.user?.photoURL,
        "phone": dataUser.user?.phoneNumber,
      });

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('user', dataUser.user!.email ?? "");

      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

      return dataUser;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 14, 16, 25),
      body: Padding(padding:
          EdgeInsets.all(20),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 45,
          ),
          Padding(
            padding: EdgeInsets.only(left: 35, right: 35),
              child: Center(child: Expanded(child: Text("Manten tus viajes seguros", textAlign: TextAlign.center, style: TextStyle(fontSize: 22))))),
          const SizedBox(
            height: 45,
          ),
          Center(child: Image.asset("assets/logo/logo1.png", cacheHeight: 150)),
          const SizedBox(
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 35, right: 35),
            child: Expanded(child: Text(
              "Comienza a sentirte mas seguro y ayuda a otros a sentirse seguros",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white60),
            )),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FilledButton.icon(
                onPressed: () => signInWithGoogle(context),
                label: const Text(
                  'Iniciar sesion con Google',
                  style: TextStyle(fontSize: 16),
                ),
                style: FilledButton.styleFrom(backgroundColor: Colors.white),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
