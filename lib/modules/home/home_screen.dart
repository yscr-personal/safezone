import 'package:flutter/material.dart';
import 'package:unb/common/widgets/base_screen_layout.dart';
import 'package:unb/modules/home/widgets/osm_map.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: OsmMap(),
    );
  }
}
