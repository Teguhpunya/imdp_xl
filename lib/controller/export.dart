import 'dart:io';

import 'package:csv/csv.dart';
import 'package:imdp_xl/database/database.queries/pembenih_query.dart';
import 'package:imdp_xl/database/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportHistory {
  late List _db;
  final DbHelper _dbHelper = DbHelper();

  void export() async {
    if (await Permission.storage.request().isGranted) {
      List<List<dynamic>> result = await convertToCsv();

      //store file in documents folder
      String now = DateFormat('HHmm-yyyy-MM-dd').format(DateTime.now());
      String filePath =
          "/storage/emulated/0/Documents" + "/quaildea-history-$now.csv";

      File f = new File(filePath);

      // convert rows to String and write as csv file
      String csv = const ListToCsvConverter().convert(result);
      f.writeAsString(csv);
    } else {
      await [
        Permission.storage,
      ].request();
    }
  }

  Future<List<List>> convertToCsv() async {
    _db = await _dbHelper.getData(PembenihQuery.TABLE_NAME);

    List<List<dynamic>> result = List.empty(growable: true);

    // Title columns
    List titles = ["Suhu 1", "Suhu 2", "Keadaan Lampu", "Waktu"];
    result.add(titles);

    // Make rows
    _db.forEach((item) {
      List<dynamic> row = List.empty(growable: true);

      row.add(item['suhu1']);
      row.add(item['suhu2']);
      row.add((item['stateLampu'] == 1) ? 'Menyala' : 'Mati');
      row.add(DateFormat('HH:mm, yyyy/MM/dd')
          .format(DateTime.fromMillisecondsSinceEpoch(item['timestamp'])));

      result.add(row);
    });
    return result;
  }
}
