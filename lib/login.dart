import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final dataUser = await FirebaseAuth.instance.signInWithCredential(credential);
      FirebaseFirestore.instance
      .collection('users')
      .add({
        "email": dataUser.user?.email,
        "name": dataUser.user?.displayName,
        "photo": dataUser.user?.photoURL,
        "phone": dataUser.user?.phoneNumber,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (dataUser.user?.email != null) {
        prefs.setString("email", dataUser.user!.email!);
      }

      return dataUser;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            
            child: FilledButton.icon(
            onPressed: signInWithGoogle, // el null deshabilita el botón
            label: const Text('Iniciar sesion con Google'),
          ),
          )
        ],
      ),
    );
  }
}
