import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/services/geolocation_service.dart';
import 'package:unb/modules/home/home_screen.dart';

class HomeModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => GeolocationService()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const HomeScreen()),
      ];
}
