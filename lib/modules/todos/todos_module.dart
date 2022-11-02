import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/modules/todos/todos_screen.dart';

class TodosModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const TodosScreen()),
      ];
}
