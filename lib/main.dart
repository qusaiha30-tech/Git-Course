import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Categories/add.dart';
import 'package:flutter_application_1/HomePage.dart';
import 'package:flutter_application_1/Test.dart';
import 'package:flutter_application_1/auth/Login.dart';
import 'package:flutter_application_1/auth/Signup.dart';
import 'package:flutter_application_1/auth/forget.dart';
import 'package:flutter_application_1/filtter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("===============================");
        print(message.notification!.title);
        print(message.notification!.body);
        print("==================================");
      }
    });

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          iconTheme: IconThemeData(color: Colors.blueAccent),
          titleTextStyle: TextStyle(
            color: Colors.blueAccent,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "Sign up": (context) => Signup(),
        "Login": (context) => Login(),
        "Homepage": (context) => Homepage(),
        "forget": (context) => Forget(),
        "addCategory": (context) => AddCategory(),
        "FiltterFireStore": (context) => FiltterFireStore(),
      },
      home: Test(), //StreamBuilder<User?>(
      //stilder: (context, snapshot) {
      //if (snapshot.connectionState == ConnectionState.waiting) {
      //return const Scaffold(
      //body: Center(child: CircularProgressIndicator()),
      //);
      //}
      //final user = snapshot.data;
      //if (user != null && user.emailVerified) {
      //return Homepage();
      //}
      //return Signup();
      //},
      //),
    );
  }
}
