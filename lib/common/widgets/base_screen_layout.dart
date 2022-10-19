import 'package:flutter/material.dart';

class BaseScreenLayout extends StatelessWidget {
  const BaseScreenLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: child,
        ),
      ),
    );
  }
}
