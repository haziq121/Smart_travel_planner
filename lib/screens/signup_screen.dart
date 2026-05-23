import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool isLoading = false;

  void signup() async {

    setState(() {
      isLoading = true;
    });

   String email =
    emailController.text.trim();

String password =
    passwordController.text.trim();

String result =
await AuthService().registerUser(

  email: email,
  password: password,
);

if(result == "success") {

  User? user =
  FirebaseAuth.instance.currentUser;

  await FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .set({

    "uid": user.uid,
    "email": email,
  });
}
    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result),
      ),
    );

    if(result == "success") {

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Signup"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            TextField(
              controller: emailController,

              decoration: InputDecoration(
                hintText: "Email",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,

              decoration: InputDecoration(
                hintText: "Password",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: signup,

                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Signup"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}