import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';
import 'package:unb/common/services/geolocation_service.dart';

class BaseScreenLayout extends StatelessWidget {
  final _authCubit = Modular.get<AuthCubit>();
  final _geoService = Modular.get<GeolocationService>();

  final Widget child;
  final String? title;

  BaseScreenLayout({
    super.key,
    required this.child,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: title == null
            ? null
            : AppBar(
                title: Text(title!),
                actions: title!.toLowerCase() != 'home'
                    ? null
                    : [
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () async {
                            await _authCubit.logout();
                            _geoService.dispose();
                            Modular.to.pushReplacementNamed('/auth/');
                          },
                        ),
                      ],
              ),
        body: SafeArea(
          child: child,
        ),
      ),
    );
  }
}
