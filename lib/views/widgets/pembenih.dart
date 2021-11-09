import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CekLampuIcon extends StatelessWidget {
  const CekLampuIcon({
    Key? key,
    required this.stateLampu,
  }) : super(key: key);

  final int stateLampu;

  @override
  Widget build(BuildContext context) {
    return Icon(
      (stateLampu == 1)
          ? FontAwesomeIcons.solidLightbulb
          : FontAwesomeIcons.lightbulb,
      color: Colors.white,
    );
  }
}
