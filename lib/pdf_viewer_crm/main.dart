import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:term/firebase_options.dart';
import 'package:term/pdf_viewer_crm/pdf/pdf_page.dart';

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
    return MaterialApp(debugShowCheckedModeBanner: false);
  }
}
