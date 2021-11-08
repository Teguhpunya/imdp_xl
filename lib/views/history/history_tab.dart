import 'package:flutter/material.dart';
import 'package:imdp_xl/database/database.queries/pembenih_query.dart';
import 'package:imdp_xl/database/db_helper.dart';
import 'package:imdp_xl/models/pembenih.dart';
import 'package:imdp_xl/views/widgets/containers.dart';
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
    return Container(
      // margin: EdgeInsets.only(top: 30),
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
            builder:
                (BuildContext context, AsyncSnapshot<List<Pembenih>> snapshot) {
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
                          MyCard(
                            color: Colors.white,
                            children: [
                              MyTextHeader(text: "Waktu"),
                              Text(
                                "${DateTime.fromMillisecondsSinceEpoch(data[index].timestamp).toLocal()}",
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: MyCard(
                                  color: Colors.white,
                                  children: [
                                    MyTextHeader(text: "Suhu 1"),
                                    Text(
                                      "${data[index].suhu1}",
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: MyCard(
                                  color: Colors.white,
                                  children: [
                                    MyTextHeader(text: "Suhu 2"),
                                    Text(
                                      "${data[index].suhu2}",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          MyCard(
                            color: Colors.white,
                            children: [
                              MyTextHeader(text: "Lampu"),
                              Text((data[index].stateLampu == 1)
                                  ? 'Menyala'
                                  : 'Mati'),
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
    );
  }
}
