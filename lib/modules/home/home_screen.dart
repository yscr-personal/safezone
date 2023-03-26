import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:unb/common/cubits/auth/auth_cubit.dart';
import 'package:unb/common/cubits/group/group_cubit.dart';
import 'package:unb/common/cubits/websocket/websocket_cubit.dart';
import 'package:unb/common/widgets/base_screen_layout.dart';
import 'package:unb/common/widgets/loading_indicator.dart';
import 'package:unb/modules/home/models/location_received_payload.dart';
import 'package:unb/modules/home/widgets/osm_map/osm_map.dart';
import 'package:unb/modules/home/widgets/osm_map/osm_map_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _logger = Modular.get<Logger>();
  final _groupCubit = Modular.get<GroupCubit>();
  final _authCubit = Modular.get<AuthCubit>();
  final _websocketCubit = Modular.get<WebsocketCubit>();
  final _mapService = Modular.get<MapService>();
  final _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _groupCubit.fetchGroups();
    _websocketCubit.listenToReceiveLocationUpdate(
      (final LocationReceivedPayload payload) {
        if (payload.userId == (_groupCubit.state as AuthLoaded).user.id) return;
        _logger.d('Received location update: $payload');
        _groupCubit.updateGroupMemberLocation(
          payload.userId,
          latitude: payload.latitude,
          longitude: payload.longitude,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BaseScreenLayout(
      overflowTop: true,
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
          body: OsmMap(
            mapController: _mapController,
          ),
        ),
      ),
    );
  }

  _buildPanel() {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case GroupLoaded:
            {
              final groupLoaded = state as GroupLoaded;
              if (groupLoaded.selected == null) {
                return const Center(
                  child: Text('Select a group to see its members'),
                );
              }
              return _buildGroupList(groupLoaded);
            }
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
        itemCount: state.selected!.members!.length,
        itemBuilder: (final context, final index) {
          final member = state.selected!.members![index];
          final hasLocation =
              member.lastLatitude != null && member.lastLongitude != null;
          return (member.id == (_authCubit.state as AuthLoaded).user.id)
              ? Container()
              : ListTile(
                  leading: CircleAvatar(
                    backgroundImage: _mapService.getMemberImage(member),
                  ),
                  title: Text(member.name!),
                  subtitle: Text(member.email!),
                  trailing: hasLocation
                      ? IconButton(
                          onPressed: () {
                            _logger.d(member.toJson());
                            _mapController.move(
                              LatLng(
                                  member.lastLatitude!, member.lastLongitude!),
                              19,
                            );
                          },
                          icon: const Icon(Icons.location_on),
                        )
                      : null,
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
