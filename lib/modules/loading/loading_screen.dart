import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/bloc/auth/auth_bloc.dart';
import 'package:unb/common/storage/user_preferences.dart';
import 'package:unb/common/widgets/base_screen_layout.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final UserPreferences userPreferences = Modular.get();
  final AuthBloc authBloc = Modular.get();

  @override
  void initState() {
    super.initState();
    _tryLogin();
  }

  _tryLogin() {
    Future.delayed(
      const Duration(seconds: 5),
      () {
        final token = userPreferences.token;
        Modular.to.pushReplacementNamed(token != null ? '/home/' : '/auth/');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const BaseScreenLayout(
      child: Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
      )),
    );
  }
}
