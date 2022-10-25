import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/modules/no_location_enabled/no_location_screen.dart';

class NoLocationServiceModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const NoLocationServiceScreen(),
        ),
      ];
}
