import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:imdp_xl/database/database.queries/pembenih_query.dart';
import 'package:imdp_xl/database/db_helper.dart';
import 'package:imdp_xl/models/pembenih.dart';
import 'package:imdp_xl/views/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

myBackgroundService() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  final dbRef = FirebaseDatabase.instance.reference();
  final DbHelper dbHelper = new DbHelper();

  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });

  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(Duration(seconds: 10), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();

    // read data from firebase
    var data, dataStr, dataJson;
    var suhu1, suhu2, stateLampu;
    Pembenih pembenih, lastData;

    dbRef.child('suhu/0').once().then((value) async {
      data = await value.value;
      dataStr = json.encode(data);
      dataJson = json.decode(dataStr);
      pembenih = pembenihFromJson(dataStr);
      suhu1 = pembenih.suhu1;
      suhu2 = pembenih.suhu2;
      stateLampu = pembenih.stateLampu;

      if (await dbHelper.hasData(PembenihQuery.TABLE_NAME)) {
        lastData =
            await dbHelper.getSingleDataPembenih(PembenihQuery.TABLE_NAME);
        if (suhu1 != lastData.suhu1 ||
            suhu2 != lastData.suhu2 ||
            stateLampu != lastData.stateLampu) {
          int currentTime = DateTime.now().millisecondsSinceEpoch;

          // change timestamp and insert data to local database
          dataJson['timestamp'] = currentTime;
          pembenih = pembenihFromJson(json.encode(dataJson));
          dbHelper.insert(PembenihQuery.TABLE_NAME, pembenih.toJson());

          // update timestamp to firebase
          dbRef.child('/suhu/${value.key}').update({'timestamp': currentTime});
        }
      } else {
        pembenih = pembenihFromJson(json.encode(dataJson));
        dbHelper.insert(PembenihQuery.TABLE_NAME, pembenih.toJson());
      }

      // set notification
      service.setNotificationInfo(
        title: "Quaildea",
        content:
            "Suhu 1: $suhu1° C\nSuhu 2: $suhu2° C\n${DateTime.fromMillisecondsSinceEpoch(dataJson['timestamp'])}",
      );
    });

    // service.sendData(
    //   {"current_date": DateTime.now().toIso8601String()},
    // );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterBackgroundService.initialize(myBackgroundService);

    return FutureBuilder(
        future: Init.instance.initialize(),
        builder: (context, AsyncSnapshot snapshot) {
          // Show splash screen while waiting for app resources to load:
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: SplashScreen(),
            );
          } else {
            // Loading is done, return the app:,
            return MaterialApp(
              title: 'Quaildea',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const Quaildea(),
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

class SplashScreen extends StatelessWidget {
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
