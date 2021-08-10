import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  List<Widget> _buildColumnsPembenih(int count) {
    return List.generate(
        count,
        (index) => Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Text("Kandang ${index + 1}"),
                  Text(
                    "${27 + Random().nextInt(31 - 27)}° C",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ));
  }

  List<Widget> _buildColumnsPetelur(int count) {
    return List.generate(
        count,
        (index) => Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Text("Kandang ${index + 1}"),
                  Text(
                    "Penuh",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('A SnackBar has been shown.'),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16),
            color: Colors.amberAccent,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Text(
                    'Kandang Pembenihan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Icon(FontAwesomeIcons.temperatureHigh),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("Suhu"),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: _buildColumnsPembenih(2),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          color: Colors.greenAccent,
          child: Column(
            children: [
              Text(
                'Kandang Petelur',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Icon(Icons.fastfood_rounded),
                        SizedBox(
                          height: 16,
                        ),
                        Text("Status tempat pakan"),
                        SizedBox(
                          height: 8,
                        ),
                        SingleChildScrollView(
                          child: Row(
                            children: _buildColumnsPetelur(2),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}