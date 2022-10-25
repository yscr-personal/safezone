import 'package:flutter/material.dart';

class BaseScreenLayout extends StatelessWidget {
  final Widget child;

  const BaseScreenLayout({
    super.key,
    required this.child,
  });

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
