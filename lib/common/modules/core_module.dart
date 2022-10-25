import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/bloc/auth/auth_bloc.dart';
import 'package:unb/common/services/dio_http_service.dart';
import 'package:unb/common/storage/user_preferences.dart';

class CoreModule extends Module {
  final AuthBloc authBloc;

  CoreModule(this.authBloc);

  @override
  List<Bind> get binds => [
        Bind.singleton((i) => DioHttpService(), export: true),
        Bind.singleton((i) => UserPreferences(), export: true),
        Bind.singleton((i) => Logger(), export: true),
        Bind.singleton((i) => authBloc, export: true),
      ];
}
