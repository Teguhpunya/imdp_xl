import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/database/database.queries/pembenih_query.dart';
import 'package:imdp_xl/database/db_helper.dart';
import 'package:imdp_xl/models/pembenih.dart';
import 'package:imdp_xl/views/widgets/containers.dart';
import 'package:imdp_xl/views/widgets/pembenih.dart';
import 'package:imdp_xl/views/widgets/texts.dart';

class HistoryView extends StatefulWidget {
  HistoryView({Key? key}) : super(key: key);

  @override
  _HistoryTab createState() => _HistoryTab();
}

class _HistoryTab extends State<HistoryView> {
  final DbHelper _dbHelper = new DbHelper();

  Stream<List<Pembenih>> _fetchData() async* {
    // This loop will run forever
    while (true) {
      // Fetch data from database
      yield await _dbHelper.getDataPembenih(PembenihQuery.TABLE_NAME);
      // Update every 10 seconds
      await Future<void>.delayed(Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        icon: FontAwesomeIcons.bars,
        backgroundColor: Colors.black,
        overlayColor: Colors.transparent,
        spacing: 16,
        children: [
          SpeedDialChild(
            label: 'Simpan sebagai Excel',
            child: Icon(FontAwesomeIcons.save),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: MyCard(color: Colors.grey[900], children: [
          Expanded(
            flex: 1,
            child: Text(
              'History',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Expanded(
            flex: 8,
            child: StreamBuilder(
              stream: _fetchData().asBroadcastStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Pembenih>> snapshot) {
                var data = snapshot.data;
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: data!.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Center(
                        child: MyCard(
                          color: Colors.black,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Icon(
                                    FontAwesomeIcons.clock,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: MyCard(
                                    children: [
                                      MyTextHeader(text: "Waktu"),
                                      Text(
                                        "${DateTime.fromMillisecondsSinceEpoch(data[index].timestamp).toLocal()}",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Icon(
                                    FontAwesomeIcons.thermometerEmpty,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: MyCard(
                                          children: [
                                            MyTextHeader(text: "Suhu 1"),
                                            Text(
                                              "${data[index].suhu1}° C",
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: MyCard(
                                          children: [
                                            MyTextHeader(text: "Suhu 2"),
                                            Text(
                                              "${data[index].suhu2}° C",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CekLampuIcon(
                                      stateLampu: data[index].stateLampu),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: MyCard(
                                    children: [
                                      MyTextHeader(text: "Lampu"),
                                      Text((data[index].stateLampu == 1)
                                          ? 'Menyala'
                                          : 'Mati'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}
