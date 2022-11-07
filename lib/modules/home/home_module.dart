import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/cubits/group/group_cubit.dart';
import 'package:unb/modules/home/home_screen.dart';

class HomeModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => GroupCubit(i())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => HomeScreen()),
      ];
}
