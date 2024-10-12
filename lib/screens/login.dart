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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          Image.asset("assets/imgs/img_login.jpg"),
          const SizedBox(
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Inicia Sesión", style: TextStyle(fontSize: 40)),
                Text(
                  "y comienza a sentirte mas seguro",
                  style: TextStyle(fontSize: 30, color: Colors.white60),
                ),
              ],
            ),
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
    );
  }
}
