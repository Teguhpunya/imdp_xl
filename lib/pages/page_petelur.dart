import 'dart:math';

import 'package:flutter/material.dart';

class PagePetelur extends StatefulWidget {
  const PagePetelur({Key? key}) : super(key: key);

  @override
  _PagePetelurState createState() => _PagePetelurState();
}

class _PagePetelurState extends State<PagePetelur> {
  bool _pakanState = Random().nextBool();

  // Pakan button
  Widget pakanButton() {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                (!_pakanState) ? Colors.redAccent.shade700 : Colors.grey)),
        onPressed: () {
          if (!_pakanState) {
            setState(() {
              _pakanState = !(_pakanState);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Sukses.'),
                  duration: Duration(milliseconds: 500)),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.fastfood_rounded),
              SizedBox(
                height: 16,
              ),
              Text("Isi Pakan"),
            ],
          ),
        ));
  }

  // Generate widget for cards
  List<Widget> _buildWidget(int count) {
    return List.generate(
        count,
        (index) => Card(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Text("Kandang ${index + 1}"),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text("Tempat Pakan"),
                          Text(
                            "${(_pakanState) ? "Penuh" : "Kosong"}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    pakanButton()
                  ]),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: _buildWidget(2));
  }
}
