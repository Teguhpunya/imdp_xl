import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdp_xl/models/model_node_temp.dart';
import 'package:imdp_xl/appState.dart';
import 'package:provider/provider.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  late MQTTAppState _state;

  @override
  Widget build(BuildContext context) {
    _state = Provider.of<MQTTAppState>(context);

    return _mainView(context);
  }

  ListView _mainView(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 64),
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
                              children: _buildColumnsPembenih(
                                  _state.getNodeTempModel),
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

  List<Widget> _buildColumnsPembenih(NodeTempModel nodes) {
    return List.generate(
        nodes.getNodes.length,
        (index) => Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Text("Kandang ${nodes.getNodes[index].getId}"),
                  Text(
                    "${nodes.getNodes[index].getSuhu}° C",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("${nodes.getNodes[index].getStateLampu}")
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
}
