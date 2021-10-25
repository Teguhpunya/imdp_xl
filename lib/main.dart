import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imdp_xl/views/homescreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Init.instance.initialize(),
        builder: (context, AsyncSnapshot snapshot) {
          // Show splash screen while waiting for app resources to load:
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Splash(),
            );
          } else {
            // Loading is done, return the app:,
            return MaterialApp(
              title: 'Quaildea',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const HomeScreen(),
            );
          }
        });
  }
}

class Init {
  Init._();

  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
        backgroundColor: lightMode
            ? Color(0xffffff).withOpacity(1.0)
            : Color(0x042a49).withOpacity(1.0),
        body: Center(
            child: Image.asset(
          'assets/images/splash-logo.png',
        )));
  }
}
