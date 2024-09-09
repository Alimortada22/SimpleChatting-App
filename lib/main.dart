import 'package:chatting_app/screens/authentication_user.dart';
import 'package:chatting_app/screens/chatsc.dart';
import 'package:chatting_app/screens/splashsc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter chat',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 17, 20, 177)),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState==ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (snapshot.hasData) {
              return const ChatScreen();
            }
            return const AuthScreen();
          }),
    );
  }
}
