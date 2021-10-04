import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';

class PageDev extends StatefulWidget {
  PageDev({Key? key}) : super(key: key);

  @override
  _PageDevState createState() => _PageDevState();
}

class _PageDevState extends State<PageDev> {
  late final GlobalKey<ExpansionTileCardState> cardA;

  @override
  void initState() {
    super.initState();
    cardA = new GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [exCard()]);
  }

  Widget exCard() {
    return ExpansionTileCard(
      // baseColor: Colors.cyan[50],
      expandedColor: Colors.red[50],
      key: cardA,
      leading: CircleAvatar(child: Image.asset("assets/images/splash.jpg")),
      title: Text("Flutter Dev's"),
      subtitle: Text("FLUTTER DEVELOPMENT COMPANY"),
      children: <Widget>[
        Divider(
          thickness: 1.0,
          height: 1.0,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              "FlutterDevs specializes in creating cost-effective and efficient applications with our perfectly crafted,"
              " creative and leading-edge flutter app development solutions for customers all around the globe.",
              style:
                  Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
            ),
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          buttonHeight: 52.0,
          buttonMinWidth: 90.0,
          children: <Widget>[
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)),
              onPressed: () {
                cardA.currentState?.expand();
              },
              child: Column(
                children: <Widget>[
                  Icon(Icons.arrow_downward),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text('Open'),
                ],
              ),
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)),
              onPressed: () {
                cardA.currentState?.collapse();
              },
              child: Column(
                children: <Widget>[
                  Icon(Icons.arrow_upward),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text('Close'),
                ],
              ),
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)),
              onPressed: () {},
              child: Column(
                children: <Widget>[
                  Icon(Icons.swap_vert),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text('Toggle'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
