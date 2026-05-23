import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {

    try {

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return "success";

    } on FirebaseAuthException catch (e) {

      return e.message ?? "Login failed";
    }
  }

  Future<String> registerUser({
    required String email,
    required String password,
  }) async {

    try {

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return "success";

    } on FirebaseAuthException catch (e) {

      return e.message ?? "Signup failed";
    }
  }
}