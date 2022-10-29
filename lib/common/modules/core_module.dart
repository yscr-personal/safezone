import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';
import 'package:unb/common/services/dio_http_service.dart';
import 'package:unb/common/storage/user_preferences.dart';

class CoreModule extends Module {
  final AuthCubit authCubit;

  CoreModule(this.authCubit);

  @override
  List<Bind> get binds => [
        Bind.singleton((i) => DioHttpService(), export: true),
        Bind.singleton((i) => UserPreferences(), export: true),
        Bind.singleton((i) => Logger(), export: true),
        Bind.singleton((i) => authCubit, export: true),
      ];
}
