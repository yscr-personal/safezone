import 'package:flutter/material.dart';

class NoLocationServiceScreen extends StatelessWidget {
  const NoLocationServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No location service enabled'),
    );
  }
}
