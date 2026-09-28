import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async {
  // Ensures Flutter is ready before calling native code like Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyphLab Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Scaffold(
        body: Center(child: Text("Firebase Database Connected!")),
      ),
    );
  }
}