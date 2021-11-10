import 'dart:convert';
import 'dart:io';

import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upgrader/upgrader.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class UpdaterView extends StatefulWidget {
  const UpdaterView({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _UpdaterViewState createState() => _UpdaterViewState(child);
}

class _UpdaterViewState extends State<UpdaterView> {
  _UpdaterViewState(this.child);

  final Widget child;

  // Flowdor
  late DownloaderCore core;
  late DownloaderUtils options;

  // Set download path
  Future<String> _setPath() async {
    if (Platform.isAndroid) {
      return (await getExternalStorageDirectory())!.path;
    }
    return (await getApplicationDocumentsDirectory()).path;
  }

  // Show download notification
  Future<void> _showProgressNotification(
      {required String title,
      required String body,
      required NotificationDetails notifDetails,
      required String payload}) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notifDetails,
      payload: payload,
    );
  }

  // Download progress notification details
  NotificationDetails _myProgressNotificationDetails(int progress) {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('quaildea_download', 'Quaildea download',
            channelDescription: 'Mengunduh versi terbaru Quaildea',
            channelShowBadge: false,
            importance: Importance.max,
            playSound: false,
            priority: Priority.high,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: 100,
            progress: progress);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    return platformChannelSpecifics;
  }

  // Finished download notification details
  NotificationDetails _myFinishedNotificationDetails() {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'quaildea_download',
      'Quaildea download',
      channelDescription: 'Mengunduh versi terbaru Quaildea',
      channelShowBadge: false,
      importance: Importance.max,
      playSound: false,
      priority: Priority.high,
      onlyAlertOnce: true,
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    return platformChannelSpecifics;
  }

  // Open downloaded file
  Future<void> _openFile(String? json) async {
    final obj = jsonDecode(json!);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Unduhan belum selesai.'),
        ),
      );
    }
  }

  // Let's download the update
  _download() async {
    Map<String, dynamic> result = {
      'appVer': Upgrader().currentAppStoreVersion() ?? '',
      'appName': Upgrader().appName(),
      'url': Upgrader().currentAppStoreListingURL() ?? '',
      'path': await _setPath(),
      'filePath': null,
      'isSuccess': false,
    };

    // Init notification
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _openFile);

    // File path
    String filePath =
        "${result['path']}/${result['appName']}-${result['appVer']}.apk";
    File downloadedFile = File(filePath);

    // Check file existence then delete it
    if (await downloadedFile.exists()) {
      downloadedFile.delete();
    }

    // Flowder stuff
    options = DownloaderUtils(
      progressCallback: (current, total) {
        final int progress = ((current / total) * 100).floor();
        print('Downloading: $progress');
        _showProgressNotification(
            title: 'Mengunduh versi terbaru',
            body: '$progress% terunduh',
            notifDetails: _myProgressNotificationDetails(progress),
            payload: jsonEncode(result));
      },
      file: File(filePath),
      progress: ProgressImplementation(),
      onDone: () {
        print('COMPLETE');
        result['isSuccess'] = true;
        result['filePath'] = filePath;
        _showProgressNotification(
            title: 'Mengunduh telah selesai',
            body: "Sentuh untuk memperbaharui ${result['appName']}",
            notifDetails: _myFinishedNotificationDetails(),
            payload: jsonEncode(result));
        _openFile(jsonEncode(result));
      },
      deleteOnCancel: true,
    );
    core = await Flowder.download(result['url'], options);
  }

  @override
  Widget build(BuildContext context) {
    final appcastURL = 'https://cast.appcastify.com/teguhpunya/imdp_xl.xml';
    final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);
    _setPath();
    return UpgradeAlert(
      appcastConfig: cfg,
      messages: MyUpgraderMessages(code: 'id'),
      // debugAlwaysUpgrade: true,
      durationToAlertAgain: Duration(minutes: 30),
      dialogStyle: UpgradeDialogStyle.cupertino,
      onUpdate: () {
        _download();
        return true;
      },
      child: child,
    );
  }
}

class MyUpgraderMessages extends UpgraderMessages {
  MyUpgraderMessages({String? code}) : super(code: code);

  @override
  String? message(UpgraderMessage messageKey) {
    if (languageCode == 'id') {
      switch (messageKey) {
        case UpgraderMessage.body:
          return 'Versi terbaru: {{currentAppStoreVersion}}\nVersi terpasang: {{currentInstalledVersion}}';
        // case UpgraderMessage.buttonTitleIgnore:
        //   return 'es Ignore';
        // case UpgraderMessage.buttonTitleLater:
        //   return 'es Later';
        // case UpgraderMessage.buttonTitleUpdate:
        //   return 'es Update Now';
        // case UpgraderMessage.prompt:
        //   return 'es Want to update?';
        case UpgraderMessage.title:
          return 'Tersedia versi terbaru Quaildea!';
      }
    }
    // Messages that are not provided above can still use the default values.
    return super.message(messageKey);
  }
}
