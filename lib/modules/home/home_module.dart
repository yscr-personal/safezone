import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/clients/safezone_api/groups_service.dart';
import 'package:unb/common/cubits/group/group_cubit.dart';
import 'package:unb/modules/home/home_screen.dart';
import 'package:unb/modules/home/widgets/osm_map/osm_map_service.dart';

class HomeModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => GroupsService(i(), i())),
        Bind((i) => GroupCubit(i())),
        Bind((i) => MapService()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const HomeScreen()),
      ];
}
