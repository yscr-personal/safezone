import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';
import 'package:unb/common/services/protocols/i_geolocation_service.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';

class BaseScreenLayout extends StatelessWidget {
  final _authCubit = Modular.get<AuthCubit>();
  final _geoService = Modular.get<IGeolocationService>();

  final Widget child;
  final String? title;
  final bool overflowTop;

  BaseScreenLayout({
    super.key,
    required this.child,
    this.title,
    this.overflowTop = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: ColorfulSafeArea(
          overflowRules: OverflowRules.only(top: overflowTop),
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
                                _geoService.stopLocationTracking();
                                Modular.to.pushReplacementNamed('/auth/');
                              },
                            ),
                          ],
                  ),
            body: child,
          ),
        ),
      ),
    );
  }
}
