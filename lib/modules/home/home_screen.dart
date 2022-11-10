import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:unb/common/cubits/group/group_cubit.dart';
import 'package:unb/common/widgets/base_screen_layout.dart';
import 'package:unb/common/widgets/loading_indicator.dart';
import 'package:unb/modules/home/widgets/osm_map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _groupCubit = Modular.get<GroupCubit>();

  @override
  void initState() {
    super.initState();
    _groupCubit.fetchGroup();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BaseScreenLayout(
      child: BlocProvider.value(
        value: _groupCubit,
        child: SlidingUpPanel(
          minHeight: height * 0.1,
          maxHeight: height * 0.5,
          backdropEnabled: true,
          parallaxEnabled: true,
          parallaxOffset: 0.5,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          header: _buildAddPersonButton(),
          panel: _buildPanel(),
          body: const OsmMap(),
        ),
      ),
    );
  }

  _buildPanel() {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case GroupLoaded:
            return _buildGroupList(state as GroupLoaded);
        }
        return const LoadingIndicator();
      },
    );
  }

  _buildGroupList(final GroupLoaded state) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: height * 0.08),
      child: ListView.builder(
        itemCount: state.group.length,
        itemBuilder: (final context, final index) {
          final member = state.group[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(member.avatarUrl!),
            ),
            title: Text(member.name!),
            subtitle: Text(member.email!),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.location_on),
            ),
          );
        },
      ),
    );
  }

  _buildAddPersonButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: 30,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Pessoas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
