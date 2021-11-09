import 'dart:io';

import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upgrader/upgrader.dart';
// ignore: implementation_imports

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
  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;

  _setPath() async {
    path = (await getExternalStorageDirectory())!.path;
  }

  _download() async {
    String appVer = Upgrader().currentAppStoreVersion() ?? '';
    String appName = Upgrader().appName();
    String urlDownload = Upgrader().currentAppStoreListingURL() ?? '';

    options = DownloaderUtils(
      progressCallback: (current, total) {
        final progress = (current / total) * 100;
        print('Downloading: $progress');
      },
      file: File('$path/$appName-$appVer.apk'),
      progress: ProgressImplementation(),
      onDone: () => print('COMPLETE'),
      deleteOnCancel: true,
    );
    core = await Flowder.download(urlDownload, options);
  }

  @override
  Widget build(BuildContext context) {
    final appcastURL = 'https://cast.appcastify.com/teguhpunya/imdp_xl.xml';
    final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);
    _setPath();
    return UpgradeAlert(
      appcastConfig: cfg,
      messages: MyUpgraderMessages(code: 'id'),
      debugAlwaysUpgrade: true,
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
