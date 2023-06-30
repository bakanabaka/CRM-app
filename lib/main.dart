import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:term/reciever_page.dart';
import 'package:term/success_page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 130,
            ),
            Container(
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: const Text(
                'Please sign in to continue',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 50),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    )
                        .then((userCredential) {
                      // Login successful
                      User? user = userCredential.user;
                      FirebaseFirestore.instance
                          .collection('adder')
                          .where('email', isEqualTo: user?.email)
                          .get()
                          .then((querySnapshot) {
                        if (querySnapshot.docs.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SuccessPage()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RecieverPage()),
                          );
                        }
                      });
                    }).catchError((error) {
                      String errorMessage = 'Your Email or Password is wrong';
                      if (error.code == 'user-not-found') {
                        errorMessage =
                            'Invalid email. Please check your email and try again.';
                      } else if (error.code == 'wrong-password') {
                        errorMessage =
                            'Invalid password. Please check your password and try again.';
                      }
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Login Error'),
                          content: Text(errorMessage),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
