import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unb/common/cubits/group/group_cubit.dart';
import 'package:unb/common/widgets/base_screen_layout.dart';
import 'package:unb/modules/home/widgets/osm_map.dart';

class HomeScreen extends StatelessWidget {
  final _groupCubit = Modular.get<GroupCubit>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      title: 'Home',
      child: BlocProvider.value(
        value: _groupCubit,
        child: const OsmMap(),
      ),
    );
  }
}
