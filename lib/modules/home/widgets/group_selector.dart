import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:unb/common/cubits/group/group_cubit.dart';
import 'package:unb/common/models/group_model.dart';

class GroupSelector extends StatefulWidget {
  const GroupSelector({super.key});

  @override
  State<GroupSelector> createState() => _GroupSelectorState();
}

class _GroupSelectorState extends State<GroupSelector> {
  final _groupCubit = Modular.get<GroupCubit>();
  final _logger = Modular.get<Logger>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      bloc: _groupCubit,
      builder: (context, state) {
        switch (state.runtimeType) {
          case GroupLoaded:
            _logger.d(
                'GroupSelector: ${state as GroupLoaded} loaded, selected: ${state.selected}');
            return _buildGroupSelector(state);
        }
        return Container();
      },
    );
  }

  _buildGroupSelector(final GroupLoaded state) {
    return Container(
      constraints: const BoxConstraints(minHeight: 48.0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: state.selected?.id ?? "null",
        icon: const Icon(Icons.arrow_drop_down),
        underline: const SizedBox(),
        items: [
          ...(state.groups.isEmpty
              ? [const GroupModel(id: 'null', name: 'Nenhum Grupo Selecionado')]
              : []),
          ...state.groups,
          const GroupModel(id: 'create-group', name: 'Criar Novo Grupo'),
        ]
            .map(
              (final group) => DropdownMenuItem<String>(
                value: group.id,
                enabled: group.id != state.selected?.id,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: group.id == state.selected?.id
                        ? Colors.blue[200]
                        : group.id == 'create-group'
                            ? Colors.green[200]
                            : Colors.transparent,
                  ),
                  child: Text(group.name),
                ),
              ),
            )
            .toList(),
        onChanged: (final String? groupId) {
          if (groupId == 'null') {
            return;
          } else if (groupId == 'create-group') {
            _logger.d('create modal');
            return;
          } else {
            _groupCubit.selectGroup(groupId!);
          }
        },
      ),
    );
  }
}
