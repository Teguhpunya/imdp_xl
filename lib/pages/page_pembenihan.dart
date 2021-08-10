import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PagePembenihan extends StatefulWidget {
  const PagePembenihan({Key? key}) : super(key: key);

  @override
  _PagePembenihanState createState() => _PagePembenihanState();
}

class _PagePembenihanState extends State<PagePembenihan> {
  bool _lampuState = Random().nextBool();

  // Generate cards
  Widget buildCard(Widget child) {
    return Card(
      elevation: 4,
      child: child,
    );
  }

  // Lampu button
  Widget lampuButton() {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                (_lampuState) ? Colors.yellow.shade800 : Colors.indigo)),
        onPressed: () {
          setState(() {
            _lampuState = !(_lampuState);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sukses.'),
              duration: Duration(milliseconds: 500),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon((_lampuState)
                  ? FontAwesomeIcons.solidLightbulb
                  : FontAwesomeIcons.lightbulb),
              SizedBox(
                height: 16,
              ),
              Text("Lampu"),
              Text(
                (_lampuState) ? "Menyala" : "Mati",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ));
  }

  // Generate widget for cards
  List<Widget> _buildWidget(int count) {
    return List.generate(
        count,
        (index) => buildCard(
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Text("Kandang ${index + 1}"),
                      Text(
                        "${27 + Random().nextInt(31 - 27)}° C",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                lampuButton(),
              ]),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Column(children: _buildWidget(2)),
      ],
    );
  }
}
